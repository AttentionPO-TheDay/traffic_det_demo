package com.ruoyi.xt.domain;

/**
 * @Auther: ac
 * @Date: 4/16/22 01:21
 * @Description: 用来测试es的简单实体类
 */
public class Book {
    private Integer id;
    private Integer userId;
    private String name;

    public Book() {
    }

    public Book(Integer id, Integer userId, String name) {
        this.id = id;
        this.userId = userId;
        this.name = name;
    }

    @Override
    public String toString() {
        return "Book{" +
            "id=" + id +
            ", userId=" + userId +
            ", name='" + name + '\'' +
            '}';
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}