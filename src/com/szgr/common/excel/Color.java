package com.szgr.common.excel;

public class Color {
	
    private byte red;
    private byte green;
    private byte blue;
    
    public Color(){
    	
    }
    
    public Color(int red,int green,int blue){
    	this.red = (byte)red;
    	this.green = (byte)green;
    	this.blue = (byte)blue;
    }
    public Color(byte red,byte green,byte blue){
    	this.red = red;
    	this.green = green;
    	this.blue = blue;
    }
    
    
	public byte getRed() {
		return red;
	}
	public void setRed(byte red) {
		this.red = red;
	}
	public byte getGreen() {
		return green;
	}
	public void setGreen(byte green) {
		this.green = green;
	}
	public byte getBlue() {
		return blue;
	}
	public void setBlue(byte blue) {
		this.blue = blue;
	}
    
}