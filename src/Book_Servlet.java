import Dao.DBUtils;
import Service.Book_Service;
import Service.impl.Book_Service_impl;
import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import pojo.Book;
import pojo.Page;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.InvocationTargetException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

public class Book_Servlet extends Servlet {
    private Book_Service book_service = new Book_Service_impl();

    public void add(HttpServletRequest req, HttpServletResponse resp) throws ServletException, InvocationTargetException, IllegalAccessException, IOException {
        Book book = new Book();
        int pageNo = Integer.parseInt(req.getParameter("pageNo"));
        try {
            BigDecimal price = new BigDecimal(req.getParameter("price"));
            int sales = Integer.parseInt(req.getParameter("sales"));
            int stock = Integer.parseInt(req.getParameter("stock"));
            BeanUtils.populate(book, req.getParameterMap());
            if (book.getStock() >= 0 && book.getPrice().compareTo(new BigDecimal(0)) >= 0 && book.getSales() >= 0) {
                book_service.add(book);
            }
            resp.sendRedirect(req.getContextPath() + "/manager/book?action=page&pageNo=" + pageNo + 1);
        } catch (Exception e) {
            req.setAttribute("msg_info", "别闹，输个正常的数字");
            req.getRequestDispatcher("/pages/manager/book_edit.jsp?method=add&pageNo=" + pageNo).forward(req, resp);
        }
    }

    public void delete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        book_service.delete(id);
        resp.sendRedirect(req.getContextPath() + "/manager/book?action=page&pageNo=" + req.getParameter("pageNo"));
    }

    public void update(HttpServletRequest req, HttpServletResponse resp) throws ServletException, InvocationTargetException, IllegalAccessException, IOException {
        Book book = new Book();
        int pageNo = Integer.parseInt(req.getParameter("pageNo"));
        try {
            BigDecimal price = new BigDecimal(req.getParameter("price"));
            int sales = Integer.parseInt(req.getParameter("sales"));
            int stock = Integer.parseInt(req.getParameter("stock"));
            BeanUtils.populate(book, req.getParameterMap());
            if (book.getStock() >= 0 && book.getPrice().compareTo(new BigDecimal(0)) >= 0 && book.getSales() >= 0) {
                book_service.update(book);
                DBUtils.commitAndClose();
            }
            resp.sendRedirect(req.getContextPath() + "/manager/book?action=page&pageNo=" + pageNo);
        } catch (Exception e) {
            req.setAttribute("msg_info", "别闹，输个正常的数字");
            req.getRequestDispatcher("/pages/manager/book_edit.jsp?method=add&pageNo=" + pageNo).forward(req, resp);
        }
    }

    public void search(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        List<Book> books = book_service.searchAll();
        req.setAttribute("books", books);
        req.getRequestDispatcher("/pages/manager/book_manager.jsp").forward(req, resp);
    }

    public void searchById(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        Book book = book_service.searchById(id);
        req.setAttribute("book", book);
        req.getRequestDispatcher("/pages/manager/book_edit.jsp").forward(req, resp);
    }

    public void page(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int pageNo = 1, pageSize = Page.PAGE_SIZE;
        String str = req.getParameter("pageNo");
        try {
            if (str != null && !str.equals(""))
                pageNo = Integer.parseInt(str);
            if (pageNo < 1)
                pageNo = 1;
        } catch (Exception e) {
            req.setAttribute("msg_info", "别闹，输个正常的数字");
        } finally {
            Page page = book_service.page(pageNo, pageSize);
            page.setUrl("manager/book?action=page");
            req.setAttribute("page", page);
            req.getRequestDispatcher("/pages/manager/book_manager.jsp").forward(req, resp);
        }
    }

    public void uploadFile(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException, FileUploadException {
        if (!ServletFileUpload.isMultipartContent(req)) {
            return;
        }
        String uploadPath = this.getServletContext().getRealPath("/img/upload");
        File uploadFile = new File(uploadPath);
        makeDirIfNotExist(uploadFile);
        String tmpPath = this.getServletContext().getRealPath("/img/tmp");
        File tmpFile = new File(tmpPath);
        makeDirIfNotExist(tmpFile);
        DiskFileItemFactory factory = getDiskFileItemFactory(tmpFile);
        ServletFileUpload servletFileUpload = getServletFileUpload(factory);
        Map<String, String> map = uploadParseRequest(req, servletFileUpload, uploadPath);
        String path = map.get("path");
        if (path != null) {
            System.out.println("文件上传成功, 路径：" + map.get("path"));
            int id = Integer.parseInt(map.get("book_id"));
            int pageNo = Integer.parseInt(map.get("pageNo"));
            book_service.imgUpdate(id, path);
            req.setAttribute("msg", "上传成功");
            req.getRequestDispatcher("/manager/book?action=searchById&id=" + id + "&method=update&pageNo=" + pageNo).forward(req, resp);
        }

    }

    private Map<String, String> uploadParseRequest(HttpServletRequest req, ServletFileUpload servletFileUpload, String uploadPath)
            throws FileUploadException, IOException {
        String path = null;
        Map<String, String> map = new HashMap<>();
        List<FileItem> fileItems = servletFileUpload.parseRequest(req);
        for (FileItem fileItem : fileItems) {
            if (fileItem.isFormField()) {
                String filedName = fileItem.getFieldName();
                String value = fileItem.getString("UTF-8");
                map.put(filedName, value);
            } else {
                String uploadFileName = fileItem.getName();
                System.out.println("上传的文件名：" + uploadFileName);
                if (uploadFileName == null || uploadFileName.trim().equals("")) {
                    continue;
                }
                String uuidPath = UUID.randomUUID().toString();
                String realPath = uploadPath + '/' + uuidPath;
                File realPathFile = new File(realPath);
                makeDirIfNotExist(realPathFile);
                InputStream is = fileItem.getInputStream();
                FileOutputStream fos = new FileOutputStream(realPathFile + "/" + uploadFileName);
                byte[] buffer = new byte[1024];
                int len;
                while ((len = is.read(buffer)) > 0) {
                    fos.write(buffer, 0, len);
                }
                path = req.getContextPath() + "/img/upload/" + uuidPath + "/" + uploadFileName;
                map.put("path", path);
                fileItem.delete();
                fos.close();
                is.close();
            }
        }
        return map;
    }

    private ServletFileUpload getServletFileUpload(DiskFileItemFactory factory) {
        ServletFileUpload servletFileUpload = new ServletFileUpload();
        servletFileUpload.setFileItemFactory(factory);
        servletFileUpload.setHeaderEncoding("UTF-8");
        // 设置单个上传文件的最大值
        servletFileUpload.setFileSizeMax(1024 * 1024 * 10); // 10M
        // 设置总共上传文件的最大值
        servletFileUpload.setSizeMax(1024 * 1024 * 10); // 10M
        return servletFileUpload;
    }

    private DiskFileItemFactory getDiskFileItemFactory(File tmpFile) {
        DiskFileItemFactory factory = new DiskFileItemFactory();
        factory.setSizeThreshold(1024 * 1024); // 1M（缓冲区大小）：上传文件大于缓冲区大小时，fileupload组件将使用临时文件缓存上传文件
        factory.setRepository(tmpFile); // 临时文件夹
        return factory;
    }

    private void makeDirIfNotExist(File file) {
        if (!file.exists()) {
            file.mkdir();
        }
    }
}
