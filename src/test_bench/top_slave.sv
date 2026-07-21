module top_slave;

  import package_slave::*;

  bit clk;
  bit rst;

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    rst = 0;
    repeat(2) @(posedge clk);
    rst = 1;
  end

  slave_if intrf(clk,rst);

  apb_slave dut(
      .PCLK(clk),
      .PRESETn(rst),
      .PADDR(intrf.PADDR),
      .PSEL(intrf.PSEL),
      .PENABLE(intrf.PENABLE),
      .PWRITE(intrf.PWRITE),
      .PWDATA(intrf.PWDATA),
      .PSTRB(intrf.PSTRB),
      .PRDATA(intrf.PRDATA),
      .PREADY(intrf.PREADY),
      .PSLVERR(intrf.PSLVERR)
  );

  assertions_slave apb_assertions(intrf);

  test_reset      t0;
test_write      t1;
test_read       t2;
test_mixed      t3;
test_boundary   t4;
test_back2back  t5;
test_wait       t6;
test_strobe     t7;
test_error      t8;
test_random     t9;


  initial begin

    $display("\n==============================");
    $display("RUNNING RESET TEST");
    $display("==============================");
    t0 = new(intrf.drv,intrf.mon);
    t0.run();

    $display("\n==============================");
    $display("RUNNING WRITE TEST");
    $display("==============================");
    t1 = new(intrf.drv,intrf.mon);
    t1.run();

    $display("\n==============================");
    $display("RUNNING READ TEST");
    $display("==============================");
    t2 = new(intrf.drv,intrf.mon);
    t2.run();

    $display("\n==============================");
    $display("RUNNING WRITE_READ TEST");
    $display("==============================");
    t3 = new(intrf.drv,intrf.mon);
    t3.run();

    $display("\n==============================");
    $display("RUNNING BOUNDARY TEST");
    $display("==============================");
    t4 = new(intrf.drv,intrf.mon);
    t4.run();

    $display("\n==============================");
    $display("RUNNING BACK_TO_BACK TEST");
    $display("==============================");
    t5 = new(intrf.drv,intrf.mon);
    t5.run();

    $display("\n==============================");
    $display("RUNNING IDLE TEST");
    $display("==============================");
    t6 = new(intrf.drv,intrf.mon);
    t6.run();

    $display("\n==============================");
    $display("RUNNING STROBE TEST");
    $display("==============================");
    t7 = new(intrf.drv,intrf.mon);
    t7.run();

    $display("\n==============================");
    $display("RUNNING INVALID ADDRESS TEST");
    $display("==============================");
    t8 = new(intrf.drv,intrf.mon);
    t8.run();

    $display("\n==============================");
    $display("RUNNING RANDOM TEST");
    $display("==============================");
    t9 = new(intrf.drv,intrf.mon);
    t9.run();

    $display("\n=========================================");
    $display("ALL REGRESSION TESTS COMPLETED");
    $display("=========================================");

    $finish;

  end

endmodule
