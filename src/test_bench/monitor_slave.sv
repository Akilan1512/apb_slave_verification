`include "defines.svh"

class monitor_slave;

  transaction_slave trans;

  mailbox #(transaction_slave) mbx_ms;

  virtual slave_if.mon vif;

 
  covergroup mon_cg;

  cp_addr : coverpoint trans.PADDR {
    bins low_addr[]  = {[0:31]};
    bins mid_addr[]  = {[32:127]};
    bins high_addr[] = {[128:255]};
    bins rest        = default;
  }

  cp_write : coverpoint trans.PWRITE {
    bins READ  = {0};
    bins WRITE = {1};
  }

  cp_psel : coverpoint trans.PSEL {
    bins LOW  = {0};
    bins HIGH = {1};
  }

  cp_penable : coverpoint trans.PENABLE {
    bins LOW  = {0};
    bins HIGH = {1};
  }

  cp_pready : coverpoint trans.PREADY {
    bins WAIT  = {0};
    bins READY = {1};
  }

  cp_pslverr : coverpoint trans.PSLVERR {
    bins OK  = {0};
    bins ERR = {1};
  }

  cp_pstrb : coverpoint trans.PSTRB;

  cp_pwdata : coverpoint trans.PWDATA;

  cp_prdata : coverpoint trans.PRDATA;

  RW_ADDR      : cross cp_write, cp_addr;

  SEL_ENABLE   : cross cp_psel, cp_penable;

  READY_RW     : cross cp_pready, cp_write;

  ERR_RW       : cross cp_pslverr, cp_write;

  STRB_WRITE   : cross cp_pstrb, cp_write;

  STRB_ADDR    : cross cp_pstrb, cp_addr;

  ERR_ADDR     : cross cp_pslverr, cp_addr;

endgroup
function new(mailbox #(transaction_slave) mbx_ms,
               virtual slave_if.mon vif);

    this.mbx_ms = mbx_ms;
    this.vif    = vif;

    mon_cg = new();

  endfunction

  task start();

    forever begin

      @(vif.mon_cb);

      if(vif.mon_cb.PSEL &&
         vif.mon_cb.PENABLE &&
         vif.mon_cb.PREADY) begin

        trans = new();

        trans.PADDR   = vif.mon_cb.PADDR;
        trans.PSEL    = vif.mon_cb.PSEL;
        trans.PENABLE = vif.mon_cb.PENABLE;
        trans.PWRITE  = vif.mon_cb.PWRITE;
        trans.PWDATA  = vif.mon_cb.PWDATA;
        trans.PSTRB   = vif.mon_cb.PSTRB;

        trans.PRDATA  = vif.mon_cb.PRDATA;
        trans.PREADY  = vif.mon_cb.PREADY;
        trans.PSLVERR = vif.mon_cb.PSLVERR;

        mon_cg.sample();

        trans.display("MONITOR");

        mbx_ms.put(trans.copy());

      end

    end

  endtask

endclass
