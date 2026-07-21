`include "defines.svh"

class driver_slave;

  transaction_slave trans;

  mailbox #(transaction_slave) mbx_gd;

  virtual slave_if.drv vif;

  function new(mailbox #(transaction_slave) mbx_gd,
               virtual slave_if.drv vif);

    this.mbx_gd = mbx_gd;
    this.vif    = vif;

  endfunction

  task reset_phase();

    vif.drv_cb.PSEL     <= 0;
    vif.drv_cb.PENABLE  <= 0;
    vif.drv_cb.PWRITE   <= 0;
    vif.drv_cb.PADDR    <= 0;
    vif.drv_cb.PWDATA   <= 0;
    vif.drv_cb.PSTRB    <= 0;

    @(vif.drv_cb);

  endtask

  task drive_transfer(transaction_slave tr);

    vif.drv_cb.PSEL     <= 1;
    vif.drv_cb.PENABLE  <= 0;
    vif.drv_cb.PWRITE   <= tr.PWRITE;
    vif.drv_cb.PADDR    <= tr.PADDR;
    vif.drv_cb.PWDATA   <= tr.PWDATA;
    vif.drv_cb.PSTRB    <= tr.PSTRB;

    @(vif.drv_cb);

    vif.drv_cb.PENABLE <= 1;

    do
      @(vif.drv_cb);
    while(vif.drv_cb.PREADY == 0);

    if(!tr.PWRITE)
      tr.PRDATA = vif.drv_cb.PRDATA;

    vif.drv_cb.PSEL    <= 0;
    vif.drv_cb.PENABLE <= 0;

    @(vif.drv_cb);

  endtask

  task start();

    wait(vif.drv_cb.PRESETn);

    reset_phase();

    repeat(`NUM_TRANS) begin

      mbx_gd.get(trans);

      trans.display("DRIVER");

      drive_transfer(trans);

    end

  endtask

endclass
