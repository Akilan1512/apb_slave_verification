`include "defines.svh"

module assertions_slave(slave_if vif);

  property p_sel_to_enable;
    @(posedge vif.PCLK)
    disable iff(!vif.PRESETn)
    $rose(vif.PSEL) |=> vif.PENABLE;
  endproperty

  assert property(p_sel_to_enable)
    else $error("PENABLE not asserted after PSEL");

  property p_addr_stable;
    @(posedge vif.PCLK)
    disable iff(!vif.PRESETn)
    (vif.PSEL && vif.PENABLE && !vif.PREADY)
      |-> $stable(vif.PADDR);
  endproperty

  assert property(p_addr_stable)
    else $error("PADDR changed during transfer");

  property p_data_stable;
    @(posedge vif.PCLK)
    disable iff(!vif.PRESETn)
    (vif.PSEL && vif.PENABLE && vif.PWRITE && !vif.PREADY)
      |-> $stable(vif.PWDATA);
  endproperty

  assert property(p_data_stable)
    else $error("PWDATA changed during write");

  property p_write_stable;
    @(posedge vif.PCLK)
    disable iff(!vif.PRESETn)
    (vif.PSEL && vif.PENABLE && !vif.PREADY)
      |-> $stable(vif.PWRITE);
  endproperty

  assert property(p_write_stable)
    else $error("PWRITE changed during transfer");

  property p_psel_high;
    @(posedge vif.PCLK)
    disable iff(!vif.PRESETn)
    vif.PENABLE |-> vif.PSEL;
  endproperty

  assert property(p_psel_high)
    else $error("PSEL deasserted while PENABLE is high");

  property p_strb_write_only;
    @(posedge vif.PCLK)
    disable iff(!vif.PRESETn)
    (!vif.PWRITE) |-> (vif.PSTRB == '0);
  endproperty

  assert property(p_strb_write_only)
    else $error("PSTRB asserted during read");

  property p_ready_after_enable;
    @(posedge vif.PCLK)
    disable iff(!vif.PRESETn)
    (vif.PSEL && vif.PENABLE) |-> ##[1:$] vif.PREADY;
  endproperty

  assert property(p_ready_after_enable)
    else $error("PREADY never asserted");

  property p_pslverr_with_ready;
    @(posedge vif.PCLK)
    disable iff(!vif.PRESETn)
    vif.PSLVERR |-> vif.PREADY;
  endproperty

  assert property(p_pslverr_with_ready)
    else $error("PSLVERR asserted without PREADY");

endmodule
