`include "defines.svh"

class transaction_slave;

  rand logic [`ADDR_WIDTH-1:0] PADDR;
  rand logic PSEL;
  rand logic PENABLE;
  rand logic PWRITE;
  rand logic [`DATA_WIDTH-1:0] PWDATA;
  rand logic [(`DATA_WIDTH/8)-1:0] PSTRB;

  logic [`DATA_WIDTH-1:0] PRDATA;
  logic PREADY;
  logic PSLVERR;

/*  constraint c_psel {
    PSEL == 1;
  }

  constraint c_penable {
    PENABLE == 0;
  }*/

  constraint c_addr {
    PADDR inside {[0:(1<<`ADDR_WIDTH)-1]};
  }

  constraint c_pstrb {
    PSTRB inside {[1:(2**(`DATA_WIDTH/8))-1]};
  }

  function transaction_slave copy();

    copy = new();

    copy.PADDR   = this.PADDR;
    copy.PSEL    = this.PSEL;
    copy.PENABLE = this.PENABLE;
    copy.PWRITE  = this.PWRITE;
    copy.PWDATA  = this.PWDATA;
    copy.PSTRB   = this.PSTRB;

    copy.PRDATA  = this.PRDATA;
    copy.PREADY  = this.PREADY;
    copy.PSLVERR = this.PSLVERR;

  endfunction

  function void display(string name="TRANS");

    $display("-----------------------------------------------");
    $display("%s",name);
    $display("PADDR    = %0h",PADDR);
    $display("PSEL     = %0b",PSEL);
    $display("PENABLE  = %0b",PENABLE);
    $display("PWRITE   = %0b",PWRITE);
    $display("PWDATA   = %0h",PWDATA);
    $display("PSTRB    = %0h",PSTRB);
    $display("PRDATA   = %0h",PRDATA);
    $display("PREADY   = %0b",PREADY);
    $display("PSLVERR  = %0b",PSLVERR);
    $display("-----------------------------------------------");

  endfunction

endclass
