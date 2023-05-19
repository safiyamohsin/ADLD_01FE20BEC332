module carpark_tb();

reg fsensor;
reg bsensor;
reg reset;
reg clk;
reg [3:0]pswd;


wire pswd_status;
wire [3:0] no_of_cars;


carpark dut(fsensor,bsensor,reset,clk,pswd,pswd_status,no_of_cars);


initial begin
fsensor = 1'b0;
bsensor  = 1'b0;
reset = 1'b1;
clk   = 1'b0;
pswd = 4'b1110;

#12
reset = 1'b0;

bsensor = 1'b0;
fsensor = 1'b1;
#10 pswd = 4'b1010;
#10 bsensor = 1'b1;
fsensor = 1'b0;

#10
bsensor = 1'b0;
fsensor = 1'b1;
#10 pswd = 4'b1110;
#10 pswd = 4'b1010;
#10 bsensor = 1'b1;
fsensor = 1'b0;
#10 bsensor = 1'b0;

$display("%t %b %b %d %d",$time,clk,pswd_status,no_of_cars,dut.state);
#100 $finish;

end


always #5 clk = ~clk;

endmodule







module carpark(fsensor,bsensor,reset,clk,pswd,pswd_status,no_of_cars);
input fsensor;
input bsensor;
input reset;
input clk;
input [3:0]pswd;
output reg pswd_status; // 1=pswd is correct, 0=pswd is wrong
output reg [3:0]no_of_cars;

reg [1:0]state,nxt_state;

parameter s0=0,  //  s0 -> car is entered which is detected by the frontsensor 
	  s1=1,  //  s1 -> Enter the pswd
	  s2=2;  //  s2 -> car is going to the parking lot as detected by backsensor 


always@(posedge clk) 
begin
	if (reset)
	begin
		state <= s0;
		no_of_cars <= 4'b0000;	
	end	
	else
		state <= nxt_state;
	end


always@(*)
begin
	case(state)
	s0 : begin
		    if(fsensor)  
			nxt_state = s1;
		    else 
			nxt_state = s0;
	     end
	s1 : begin
	    	
		if(pswd == 4'b1010)
		begin
		   pswd_status = 1'b1;
		   nxt_state = s2;
	        end

	    else 

		begin
		   pswd_status = 1'b0;
		   nxt_state = s1;		   
		
		end
	    end
	s2 : begin
	     if(bsensor)
	     begin
		no_of_cars = no_of_cars + 1'b1;   //counting the number of cars
		nxt_state = s0;
	     end
	    else
		begin
		nxt_state = s2;
		end
	     end
	default : begin
		nxt_state = s0;
		pswd_status = 1'b0;
		no_of_cars = 4'b0000;
	end
	endcase
end

endmodule 
