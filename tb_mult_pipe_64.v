`timescale 1ns / 1ps

module tb_mult_pipe_64;

parameter PERIOD = 20;

reg              clk;
reg              rst_n;

reg     [63:0]   op1;
reg     [63:0]   op2;
wire    [127:0]  result;
reg     [127:0]  ref_result;

mult_pipe_64 mult_inst (.i_CLK (clk), 
                        .i_RST_n (rst_n), 
                        .i_OP1 (op1), 
                        .i_OP2 (op2), 
                        .o_RESULT (result)
                        );

initial begin
    clk = 1'b0;
    forever #(PERIOD/2) clk = ~clk;
end

initial begin
    rst_n = 1'b0;
    op1 = 0;
    op2 = 0;
    ref_result = 0;
    repeat (5) @(negedge clk);
    rst_n = 1'b1;
    repeat (5) @(negedge clk);

    repeat (1000) begin
        if (ref_result !== result)
            $display("MISMATH! ref_result=%d result=%d", ref_result, result);
        op1 = {$random, $random};
        op2 = {$random, $random};
        ref_result = op1*op2;
        repeat (5) @(negedge clk);
    end

    $finish;

end

endmodule // tb
