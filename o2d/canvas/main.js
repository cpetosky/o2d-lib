function Map(renderer) {
	var self = this;
	self.renderer = renderer;
}

function Entity(image, speed) {
	var self = this;
	self.image = image;
	self.x = self.y = 0;
	self.velocityX = self.velocityY = 0;
	self.speed = (speed || 100) / 1000;
	
	self.move = function (delta) {
		var distance = delta * self.speed;
		self.x += distance * self.velocityX;
		self.y += distance * self.velocityY;
	}
}

function Game(canvas, output) {
	var self = this;
	self.output = output;
	
	self.canvas = canvas[0];
	
	if (!self.canvas.getContext) {
		output.text("Your browser does not support the HTML 5 <canvas> element.");
		return;
	}
	
	self.renderer = self.canvas.getContext("2d");
	
	self.entities = [];

	self.start = function () {
		self.lastTime = new Date().getTime();
		
		$(document).keydown(self.handleKeyDown);
		$(document).keyup(self.handleKeyUp);

		image = new Image();
		image.onload = function () {
			setInterval(self.render, 1000 / 30); // Cap at ~30 FPS
		}
		image.src = "http://files.petosky.net/o2d/content/gfx/entities/fighter.png";
		self.player = new Entity(image);
		self.entities.push(self.player);
	};
	
	self.render = function () {
		var currentTime = new Date().getTime();
		var delta = currentTime - self.lastTime;
		self.lastTime = currentTime;
		
		self.renderer.clearRect(0, 0, self.canvas.width, self.canvas.height);
		
		for (var i = 0; i < self.entities.length; ++i) {
			var entity = self.entities[i];
			entity.move(delta);
			
			self.output.text("" + entity.x + "," + entity.y);
			self.renderer.drawImage(entity.image, 0, 0, 32, 48, 
					entity.x, entity.y, 32, 48);
		}
	};
	
	self.handleKeyDown = function (event) {
		switch (event.which) {
			case 87: // W
				self.player.velocityY = -1.0;
				break;
				
			case 83: // S
				self.player.velocityY = 1.0;
				break;
				
			case 65: // A
				self.player.velocityX = -1.0;
				break;
				
			case 68: // D
				self.player.velocityX = 1.0;
				break;
		}
	}
	
	self.handleKeyUp = function (event) {
		switch (event.which) {
			case 87: // W
			case 83: // S
				self.player.velocityY = 0;
				break;
				
			case 65: // A
			case 68: // D
				self.player.velocityX = 0;
				break;
		}		
	}
}
