/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package model;

import javax.servlet.ServletException;

/**
 *
 * @author user
 */
public class RequestException extends ServletException {
    public RequestException(String s) {
        super(s);
    }
}
