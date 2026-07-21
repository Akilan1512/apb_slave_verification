class test_mixed extends test_slave;

  function new(virtual slave_if.drv drv_vif,
               virtual slave_if.mon mon_vif);
    super.new(drv_vif,mon_vif);
  endfunction

  virtual task run();
    env = new(drv_vif,mon_vif);
    env.build();
    env.gen.test_type = generator_slave::WRITE_READ;
    env.start();
  endtask

endclass
