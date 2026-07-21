`include "defines.svh"

interface slave_if(input bit PCLK,input bit PRESETn);

logic [`ADDR_WIDTH-1:0] PADDR;
logic PSEL;
logic PENABLE;
logic PWRITE;
logic [`DATA_WIDTH-1:0] PWDATA;
logic [(`DATA_WIDTH/8)-1:0] PSTRB;

logic [`DATA_WIDTH-1:0] PRDATA;
logic PREADY;
logic PSLVERR;

clocking drv_cb @(posedge PCLK);
default input #1 output #1;
input PRESETn;
input PRDATA;
input PREADY;
input PSLVERR;
output PADDR;
output PSEL;
output PENABLE;
output PWRITE;
output PWDATA;
output PSTRB;
endclocking

clocking mon_cb @(posedge PCLK);
default input #1 output #1;
input PRESETn;
input PADDR;
input PSEL;
input PENABLE;
input PWRITE;
input PWDATA;
input PSTRB;
input PRDATA;
input PREADY;
input PSLVERR;
endclocking

modport drv(clocking drv_cb);

modport mon(clocking mon_cb);

endinterface
