`include "defines.svh"

class test_slave;

  environment_slave env;

  virtual slave_if.drv drv_vif;
  virtual slave_if.mon mon_vif;

  function new(
      virtual slave_if.drv drv_vif,
      virtual slave_if.mon mon_vif
  );

    this.drv_vif = drv_vif;
    this.mon_vif = mon_vif;

  endfunction

  virtual task run();

    env = new(
              drv_vif,
              mon_vif
            );

    env.run();

  endtask

endclass
