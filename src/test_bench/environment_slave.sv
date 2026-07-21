`include "defines.svh"

class environment_slave;

  generator_slave  gen;
  driver_slave     drv;
  monitor_slave    mon;
  scoreboard_slave scb;

  mailbox #(transaction_slave) mbx_gd;
  mailbox #(transaction_slave) mbx_ms;

  virtual slave_if.drv drv_vif;
  virtual slave_if.mon mon_vif;

  function new(
      virtual slave_if.drv drv_vif,
      virtual slave_if.mon mon_vif
  );

    this.drv_vif = drv_vif;
    this.mon_vif = mon_vif;

  endfunction

  task build();

    mbx_gd = new();
    mbx_ms = new();

    gen = new(mbx_gd);

    drv = new(
              mbx_gd,
              drv_vif
            );

    mon = new(
              mbx_ms,
              mon_vif
            );

    scb = new(
              mbx_ms
            );

  endtask

  task start();

    fork

      gen.start();

      drv.start();

      mon.start();

      scb.start();

    join_none
    #1000;
   
  endtask

  task run();

    build();

    start();

  endtask

endclass
