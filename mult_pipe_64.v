module mult_pipe_64(i_CLK, i_RST_n, i_OP1, i_OP2, o_RESULT);

input           i_CLK;
input           i_RST_n;
input   [63:0]  i_OP1;
input   [63:0]  i_OP2;
output  [127:0] o_RESULT;
       

wire [31:0] a = i_OP1[63:32];
wire [31:0] b = i_OP1[31:0];
wire [31:0] c = i_OP2[63:32];
wire [31:0] d = i_OP2[31:0];

reg  [31:0] a_r;  
reg  [31:0] b_r; 
reg  [31:0] c_r; 
reg  [31:0] d_r; 

reg  [63:0] ac_r;
reg  [63:0] bd_r;
reg  [63:0] bc_r;
reg  [63:0] ad_r;


reg  [127:0] ac_plus_bd_r;
reg  [127:0] bc_plus_ad_r;

reg  [127:0] result_r;


always @(posedge i_CLK, negedge i_RST_n)
    if (~i_RST_n) begin
        a_r <= 32'd0;
        b_r <= 32'd0;
        c_r <= 32'd0;
        d_r <= 32'd0;
    end else begin
        a_r <= a;
        b_r <= b;
        c_r <= c;
        d_r <= d;
    end

always @(posedge i_CLK, negedge i_RST_n)
    if (~i_RST_n) begin
        bd_r <= 64'd0;
        bc_r <= 64'd0;
        ad_r <= 64'd0;
        ac_r <= 64'd0;
    end else begin
        bd_r <= b_r * d_r;
        bc_r <= b_r * c_r;
        ad_r <= a_r * d_r;
        ac_r <= a_r * c_r;
    end

always @(posedge i_CLK, negedge i_RST_n)
    if (~i_RST_n) begin
        ac_plus_bd_r <= 128'd0;
        bc_plus_ad_r <= 128'd0;
    end else begin
        ac_plus_bd_r <= bd_r + (ac_r << 64);
        bc_plus_ad_r <= (bc_r << 32) + (ad_r << 32);
    end

always @(posedge i_CLK, negedge i_RST_n)
    if (~i_RST_n) begin
        result_r <= 128'd0;
    end else begin
        result_r <= ac_plus_bd_r + bc_plus_ad_r;
    end

assign o_RESULT = result_r;

endmodule
