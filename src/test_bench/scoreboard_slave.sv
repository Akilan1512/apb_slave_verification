`include "defines.svh"

class scoreboard_slave;

  transaction_slave trans;

  mailbox #(transaction_slave) mbx_ms;

  logic [`DATA_WIDTH-1:0] ref_mem [(1<<`ADDR_WIDTH)-1:0];

  int MATCH;
  int MISMATCH;

  function new(mailbox #(transaction_slave) mbx_ms);

    this.mbx_ms = mbx_ms;

    MATCH = 0;
    MISMATCH = 0;

    foreach(ref_mem[i])
      ref_mem[i] = '0;

  endfunction

  task start();

    forever begin

      mbx_ms.get(trans);

      if(trans.PSLVERR) begin

        $display("--------------------------------");
        $display("SCOREBOARD : SLAVE ERROR");
        $display("ADDR = %0h",trans.PADDR);
        $display("--------------------------------");

        continue;

      end

      if(trans.PWRITE) begin

        for(int i=0;i<(`DATA_WIDTH/8);i++) begin

          if(trans.PSTRB[i])
            ref_mem[trans.PADDR][8*i +: 8] =
                     trans.PWDATA[8*i +: 8];

        end

        $display("--------------------------------");
        $display("SCOREBOARD WRITE");
        $display("ADDR=%0h DATA=%0h",
                 trans.PADDR,
                 ref_mem[trans.PADDR]);
        $display("--------------------------------");

      end

      else begin

        if(ref_mem[trans.PADDR] == trans.PRDATA) begin

          MATCH++;

          $display("--------------------------------");
          $display("READ MATCH");
          $display("ADDR     = %0h",trans.PADDR);
          $display("EXPECTED = %0h",ref_mem[trans.PADDR]);
          $display("ACTUAL   = %0h",trans.PRDATA);
          $display("--------------------------------");

        end

        else begin

          MISMATCH++;

          $display("--------------------------------");
          $display("READ MISMATCH");
          $display("ADDR     = %0h",trans.PADDR);
          $display("EXPECTED = %0h",ref_mem[trans.PADDR]);
          $display("ACTUAL   = %0h",trans.PRDATA);
          $display("--------------------------------");

        end

      end

    end

  endtask

  function void report();

    $display("");
    $display("=======================================");
    $display("SCOREBOARD REPORT");
    $display("MATCH     = %0d",MATCH);
    $display("MISMATCH  = %0d",MISMATCH);
    $display("=======================================");

  endfunction

endclass
