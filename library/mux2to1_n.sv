module mux2to1_n #(parameter n=4) (
    input logic [n-1:0] w0_i,
    input logic [n-1:0] w1_i,
    input logic sel_i,
    output logic [n-1:0] y_o
);

    always_comb begin : proc_mux2_4bit
        for (int i = 0; i < n; i++)
            y_o[i] = sel_i&w1_i[i]|~sel_i&w0_i[i];
    end

endmodule : mux2to1_n
