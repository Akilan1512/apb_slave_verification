class test_boundary extends test_slave;

  function new(virtual slave_if.drv drv_vif,
               virtual slave_if.mon mon_vif);
    super.new(drv_vif,mon_vif);
  endfunction

  virtual task run();
    env = new(drv_vif,mon_vif);
    env.build();
    env.gen.test_type = generator_slave::BOUNDARY;
    env.start();
  endtask

endclass
