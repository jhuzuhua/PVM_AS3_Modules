package com.Joshua{
    import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;

    public class Main extends MovieClip
    {
		
		//global variables
		var oldX:Number;
		var oldY:Number;
		var targetArray: Array;
		var draggablesArray: Array;
		var noOfTargets: Number = 2;
		var xCoordinates: Array;
		var yCoordinates: Array;
		var showAnswerFlag: Boolean = false;
		
        public function Main(){
			trace("yep! it's working!");
			
			var bnames:Array = ["", "3.7948", "4.00", "4.00", "4.00", "4.00"];
			var bvalues:Array = ["", "3.7948", "4.00", "4.00", "4.00", "4.00"];
			
			xCoordinates = [-86.80, -176.89, -176.89, -176.89, -176.89];
			yCoordinates = [148.20, 59.40, 77.60, 95.60, 113.80];
			
			var summit:int = 1000;
			
			trace(MovieClip(root).getChildByName("main_mc").name);
			
			var mc: MovieClip = MovieClip(root).getChildByName("main_mc") as MovieClip;			
			var cpuMC: MovieClip = mc.getChildByName("cpu") as MovieClip;
			
			var draggables: Array = [cpuMC.c1, cpuMC.c2, cpuMC.c3, cpuMC.c4, cpuMC.c5];
			draggablesArray = draggables;
			targetArray = ["", 0, 0];
			
			resetsol(draggables);
			
        }
		
		/*
		// Hides all check and wrong marks
		//	Parameter: Draggables array
		//  Return: 
		*/
		public function resetsol(draggables : Array){
			
			for (var i: uint = 0; i < draggables.length; i++){
				
				trace(draggables[i].name);
				
				draggables[i].check.alpha = 0;
				draggables[i].wrong.alpha = 0;
				
				var textFormat: TextFormat = new TextFormat();
				
				if (i == 0) textFormat.color = 0xFFFFFF;
				else 		textFormat.color = 0x000000;
				
				textFormat.size = 10;
				
				draggables[i].tf.setTextFormat(textFormat);
				draggables[i].enabled = true;
				
				draggables[i].addEventListener(MouseEvent.MOUSE_DOWN, pressed);
				draggables[i].addEventListener(MouseEvent.MOUSE_UP, released);
				
			}
			
		} 
		
		
		/*
		// This function is called to clear all check and wrong marks
		//	Parameter: draggable - the dragged movieClip
		//  Return: 
		*/
		public function clearMarks(draggable: MovieClip){
				
			draggable.check.alpha = 0;
			draggable.wrong.alpha = 0;
		}
		
		
		/*
		// This function is called once the mouse has been pressed
		//	 Parameter: MouseEvent
		//  Return: 
		*/
		public function pressed(e: MouseEvent): void{
				
			//e.target.startDrag();
			var mc: MovieClip = e.target.parent as MovieClip;
			mc.startDrag();
			trace("start drag");
			
			clearMarks(mc);
			
			for (var i: String in draggablesArray){
				if (mc == draggablesArray[i]){
					oldX = xCoordinates[i];
					oldY = yCoordinates[i];
					
					break;
				}
			}
			
			//oldX = mc.x;
			//oldY = mc.y;
			
		}
		
		
		/*
		// This function is called once the mouse has been released
		//	 Parameter: MouseEvent
		//  Return: 
		*/
		public function released(e: MouseEvent):void{
			
			var mc: MovieClip = e.target.parent as MovieClip;
			mc.stopDrag();
			trace("stop drag");
			
			var hits: Number = 0;
			var currentTarget: Number = 0;
			
			//get currentTargetName
			for (var j = 1; j <= noOfTargets; j++){
				
					trace("checking target " + j);
					var currentTargetMC : MovieClip = MovieClip(root)["main_mc"].cpu.getChildByName("t"+j) as MovieClip;
					
					trace( "dragged " + mc.name + "(" + mc.getBounds(stage) + ")");
					trace( "on target" + j + "(" + currentTargetMC.getBounds(stage) + ")");
				
					//check if it hits target
					if (mc.hitTestObject(currentTargetMC)){
						
						hits = 1;
					
						trace("confirmed hit for t" + j);
						
						var isAvailable: Boolean;
						
						//check for availability
						isAvailable = checkIfAvailable(j);
						
						if (!isAvailable){
							resetButton(mc);
							trace("not available");
						} 
						
						else {
							
							trace("still available");
							
							//setCoordinates for draggable
							mc.x = currentTargetMC.x;
							mc.y = currentTargetMC.y;
							
							//hide the s1 or s2 components
							MovieClip(root)["main_mc"].cpu.getChildByName("s"+j).visible = false;
							
							targetArray[j] = 1;							
							setStyleForDroppedItem(mc);
							checkSolution(mc, j);
							
							
							break;
						}
						
					}
			}
			
			//check if hits a target or not
			//reset if hits nothing
			if (hits == 0) resetButton(mc);
			
		}
		
		/*
		// This function sends the draggable button back to its original position
		// Parameter: draggable item with MovieClip datatype
		//
		*/
		public function resetButton(draggable: MovieClip): void{
			draggable.x = oldX;
			draggable.y = oldY;
			
			var textFormat: TextFormat = new TextFormat();
			if (draggable.name == "c1") textFormat.color = 0xFFFFFF;
			else 		textFormat.color = 0x000000;
			
			textFormat.size = 10;
			
			draggable.tf.setTextFormat(textFormat);
			
			checkDraggables();
		}
		
		
		/*
		// This function is called to check if the solution is correct or wrong
		// Parameters: Draggable Item: MovieClip - the draggable item
					   targetNumber: Number - target number of the drop area
		// Return: 
		*/
		public function checkIfAvailable(targetNumber: Number): Boolean {
			var empty = targetArray[targetNumber];
			
			if (empty == 1) return false;
				
			return true;
		}
		
		/*
			
			
		*/
		public function setStyleForDroppedItem(draggable: MovieClip){
			var textFormat: TextFormat = new TextFormat();
			textFormat.color = 0x000000;
			textFormat.size = 14;
			
			draggable.tf.setTextFormat(textFormat);
		}
		
		
		/*
		// This function is called to check if the solution is correct or wrong
		// Parameters: Draggable Item: MovieClip - the draggable item
								targetNumber: Number - target number of the drop area
		//  Return: 
		*/
		public function checkSolution(draggable: MovieClip, targetNumber: Number){
			
			//check for specific target and movieClip
			
			//for target 1
			if (targetNumber == 1){
				if (draggable == draggablesArray[0]){
					trace("draggable c1");
					draggable.check.alpha = 100;
					draggable.wrong.alpha = 0;
					showAnswerFlag = true;
				}
			
				else{
				
					trace("draggable c2-5");
					draggable.check.alpha = 0;
					draggable.wrong.alpha = 100;
				}
			}
			
			//target 2
			else if (targetNumber == 2){
				if (draggable == draggablesArray[0]){
					trace("draggable c1");
					draggable.check.alpha = 0;
					draggable.wrong.alpha = 100;
					showAnswerFlag = true;
				}
			
				else{
				
					trace("draggable c2-5");
					draggable.check.alpha = 100;
					draggable.wrong.alpha = 0;
				}
			}
			
			
			//case when all targets are occupied
			trace(targetArray);
			trace(showAnswerFlag);
			
			if (targetArray[1] == 1 && targetArray[2] == 1){
				
				if (showAnswerFlag){
					var mc: MovieClip = MovieClip(root).getChildByName("main_mc") as MovieClip;			
					var cpuMC: MovieClip = mc.getChildByName("cpu") as MovieClip;
					cpuMC.anstot.text = "15.18";
				}
				
			}
			
		}
		
		
		/*
		// This function checks if there are draggables on the targets
		// Parameters: 
		// Return: 
		*/
			
		public function checkDraggables(){
			
			for (var j = 1; j <= noOfTargets; j++){
				
					trace("checking target " + j);
					var currentTargetMC : MovieClip = MovieClip(root)["main_mc"].cpu.getChildByName("t"+j) as MovieClip;
					
					for (var i: uint = 0; i < draggablesArray.length; i++){
					
						var mc : MovieClip = draggablesArray[i] as MovieClip;
						
						//check if it hits target
						if (mc.hitTestObject(currentTargetMC)){
							
							trace("there is a draggable in target "+j);
							MovieClip(root)["main_mc"].cpu.getChildByName("s"+j).visible = false;
							break;
							
						}
						
						else {
							
							MovieClip(root)["main_mc"].cpu.getChildByName("s"+j).visible = true;
							MovieClip(root)["main_mc"].cpu.anstot.text = "";
							targetArray[j] = 0;
							
						}
					
					} //end of inner for loop
					
			} //end of first for loop
			
		}
		
	} //end of Main
	
} //end of package