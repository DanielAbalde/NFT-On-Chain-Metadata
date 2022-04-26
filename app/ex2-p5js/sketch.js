var url = new URL(window.location.href);
 
var frontColor;
var backColor;
var radius;

function preload(){
  frontColor = getUrlValue('frontColor', 'white');
  backColor = getUrlValue('backColor', 'black');
  radius = getUrlValue('radius', 30);
}

function setup(){
  createCanvas(windowWidth, windowHeight);
  background(backColor);
  stroke(backColor);
  fill(frontColor); 
}

function draw(){
  ellipse(mouseX, mouseY, radius, radius);
}

function getUrlValue(name, defaultValue){
	var value = url.searchParams.get(name);
	if(value){  
    if (typeof defaultValue == "boolean") {
			return parseBoolean(value);
		}
		else if (typeof defaultValue == "number") {
			if(value.startsWith("0x"))
				return parseInt(value);
			return parseFloat(value);
		}
		return value;
	}else{
		return defaultValue;
	}
}

function windowResized() {
  resizeCanvas(windowWidth, windowHeight); 
}