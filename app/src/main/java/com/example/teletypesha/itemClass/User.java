package com.example.teletypesha.itemClass;

public class User {
    private String name;

    public User(String name){
        this.name = name;
    }

    public User(){

    }

    public String GetName(){
        return name;
    }

    public void SetName(String name){
        this.name = name;
    }
}
