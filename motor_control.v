`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:20:35 11/04/2013 
// Design Name: 
// Module Name:    motor_control 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module motor_control(
   clk,
	rst,
	MOTOR_SSEL,
	IR_catch,
	pwm_up_en,//控制pwm是否输出 即电机是否转动//连接pwm 输出模块
	pwm_down_en,
	up_speed_up,
	up_speed_down,
	down_speed_up,
	down_speed_down,
	UP_HIGH_SET,
	DOWN_HIGH_SET
);

input clk;
input rst;
input [3:0] MOTOR_SSEL;
input IR_catch;//红外对管接收
output pwm_up_en;//控制上下pwm是否输出
output pwm_down_en;//控制上下pwm是否输出
output up_speed_up,up_speed_down;
output down_speed_up,down_speed_down;
output [31:0] UP_HIGH_SET;
output [31:0] DOWN_HIGH_SET;

wire rst_n;
reg pwm_up_en;
reg pwm_down_en;
//assign  pwm_up_en = 1'b1;//reg pwm_up_en;//reg pwm_down_en;
//assign  pwm_down_en = 1'b1;

reg up_speed_up;
reg up_speed_down;
reg down_speed_up;
reg down_speed_down;

reg [31:0] UP_HIGH_SET ;//reg [31:0] UP_HIGH_SET;
reg [31:0] DOWN_HIGH_SET;//reg [31:0] DOWN_HIGH_SET;
//assign UP_HIGH_SET =32'd100_000;
//assign DOWN_HIGH_SET =32'd100_000;


reg [31:0] i;
reg [31:0] T_c;
reg [31:0] T_set;

parameter motor_ssel_0 = 4'd0;//都不转
parameter motor_ssel_1 = 4'd1;//上转速快下不转
parameter motor_ssel_2 = 4'd2;//下转转速快上不转
parameter motor_ssel_3 = 4'd3;//上转速快下转速中
parameter motor_ssel_4 = 4'd4;//上转速快下转速快
parameter motor_ssel_5 = 4'd5;//上转速max快下转速慢
parameter motor_ssel_6 = 4'd6;//上转速max快下转速中

parameter up_high_set_max= 32'd550;//上转速快//设置pwm 占空比520-1_000_000
parameter up_high_set0= 32'd500;//上转速快//设置pwm 占空比520-1_000_000
parameter up_high_set1= 32'd400;//上转速中
parameter up_high_set2= 32'd350;//上转速慢

parameter down_high_set0=32'd130;//下转速快
parameter down_high_set1=32'd115;//下转速中
parameter down_high_set2=32'd110;//下转速慢+


assign rst_n = ~rst;

//上下电机转速控制
always @ (posedge clk or negedge rst_n)//只有negedge rst_n进入模块，才会执行if (! rst_n)中的语句？？？
begin
	if (! rst_n)
	begin
		pwm_up_en = 1'b1;//
		pwm_down_en = 1'b1;//
		UP_HIGH_SET = 32'd100_000;//
		DOWN_HIGH_SET = 32'd100_000;//
	end
	else 
	begin
		case (MOTOR_SSEL)
			motor_ssel_0 : begin	
									pwm_up_en = 1'b0;
									pwm_down_en = 1'b0;
									UP_HIGH_SET = up_high_set0;
									DOWN_HIGH_SET = down_high_set0;
								end
			motor_ssel_1 : begin	
									pwm_up_en = 1'b1;
									pwm_down_en = 1'b0;
									UP_HIGH_SET = up_high_set0;
									DOWN_HIGH_SET = down_high_set0;
								end
			motor_ssel_2 : begin	
									pwm_up_en = 1'b0;
									pwm_down_en = 1'b1;
									UP_HIGH_SET = up_high_set0;//上转速快
									DOWN_HIGH_SET = down_high_set0;//下转速快
								end
			motor_ssel_3 : begin	
									pwm_up_en = 1'b1;
									pwm_down_en = 1'b1;
									UP_HIGH_SET = up_high_set0;//上转速快
									DOWN_HIGH_SET = down_high_set1;//下转速中
								end
			motor_ssel_4 : begin	
									pwm_up_en = 1'b1;
									pwm_down_en = 1'b1;
									UP_HIGH_SET = up_high_set0;//上转速快
									DOWN_HIGH_SET = down_high_set0;//下转速快
								end
			motor_ssel_5 : begin	
									pwm_up_en = 1'b1;
									pwm_down_en = 1'b1;
									UP_HIGH_SET = up_high_set_max;//上转速快
									DOWN_HIGH_SET = down_high_set2;//下转速慢
								end
			motor_ssel_6 : begin	
									pwm_up_en = 1'b1;
									pwm_down_en = 1'b1;
									UP_HIGH_SET = up_high_set_max;//上转速快
									DOWN_HIGH_SET = down_high_set1;//下转速中
								end
	
			default : begin	
									pwm_up_en = 1'b0;
									pwm_down_en = 1'b0;
									UP_HIGH_SET = up_high_set0;
									DOWN_HIGH_SET = down_high_set0;
								end

		endcase 
	end
end 

/*
//速度采集
always @ (posedge clk or posedge IR_catch)
begin
	if (!IR_catch)
	begin
		i <=i + 1;
	end
	else 
		T_c <= i; 
		i <= 0;
end

//闭环反馈控速(需分上下 没写完！！！！)
always @ (posedge clk or negedge rst_n)
begin
	if (!rst_n)
	begin
		speed_up = 0;
		speed_down = 0;
	end
	else 
	begin
		if (T_c < T_set)
		begin
			speed_up = 0;
			speed_down = 1;
		end
		else if (T_c == T_set)
		begin
			speed_up = 0;
			speed_down = 0;
		end
		else if (T_c > T_set)
		begin
			speed_up = 1;
			speed_down = 0;
		end
	end
end
*/
endmodule
