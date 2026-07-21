`include "defines.svh"

class generator_slave;

   typedef enum int {
      RESET,
      WRITE_ONLY,
      READ_ONLY,
      WRITE_READ,
      BACK_TO_BACK,
      BOUNDARY,
      RANDOM,
      WAIT_STATE,
      ERROR_TEST,
      STROBE
   } test_type_e;

   mailbox #(transaction_slave) mbx_gd;

   transaction_slave trans;

   test_type_e test_type;

   int num_trans = 50;

   function new(mailbox #(transaction_slave) mbx_gd);
      this.mbx_gd = mbx_gd;
   endfunction


   task start();
      case(test_type)
         RESET        : reset_test();
         WRITE_ONLY   : write_only_test();
         READ_ONLY    : read_only_test();
         WRITE_READ   : write_read_test();
         BACK_TO_BACK : back_to_back_test();
         BOUNDARY     : boundary_test();
         RANDOM       : random_test();
         WAIT_STATE   : wait_state_test();
         ERROR_TEST   : error_test();
         STROBE       : strobe_test();
         default      : random_test();
      endcase
   endtask


   task reset_test();

      repeat(5) begin
         trans = new();

         trans.PSEL     = 0;
         trans.PENABLE  = 0;
         trans.PWRITE   = 0;
         trans.PADDR    = '0;
         trans.PWDATA   = '0;
         trans.PSTRB    = '0;

         mbx_gd.put(trans);
      end

   endtask



   task write_only_test();

      repeat(num_trans) begin

         trans = new();

         assert(trans.randomize() with {
            PSEL     == 1;
            PENABLE  == 1;
            PWRITE   == 1;
         });

         mbx_gd.put(trans);

      end

   endtask



   task read_only_test();

      repeat(num_trans) begin

         trans = new();

         assert(trans.randomize() with {
            PSEL     == 1;
            PENABLE  == 1;
            PWRITE   == 0;
         });

         mbx_gd.put(trans);

      end

   endtask



   task write_read_test();

      repeat(num_trans) begin

         trans = new();

         assert(trans.randomize() with {
            PSEL     == 1;
            PENABLE  == 1;
            PWRITE   == 1;
         });

         mbx_gd.put(trans);


         trans = new();

         assert(trans.randomize() with {
            PSEL     == 1;
            PENABLE  == 1;
            PWRITE   == 0;
         });

         mbx_gd.put(trans);

      end

   endtask



   task back_to_back_test();

      repeat(num_trans) begin

         trans = new();

         assert(trans.randomize() with {
            PSEL     == 1;
            PENABLE  == 1;
         });

         mbx_gd.put(trans);

      end

   endtask



   task boundary_test();

      trans = new();

      assert(trans.randomize() with {
         PSEL     == 1;
         PENABLE  == 1;
         PWRITE   == 1;
         PADDR    == '0;
      });

      mbx_gd.put(trans);


      trans = new();

      assert(trans.randomize() with {
         PSEL     == 1;
         PENABLE  == 1;
         PWRITE   == 1;
         PADDR    == {`ADDR_WIDTH{1'b1}};
      });

      mbx_gd.put(trans);


      trans = new();

      assert(trans.randomize() with {
         PSEL     == 1;
         PENABLE  == 1;
         PWRITE   == 0;
         PADDR    == '0;
      });

      mbx_gd.put(trans);


      trans = new();

      assert(trans.randomize() with {
         PSEL     == 1;
         PENABLE  == 1;
         PWRITE   == 0;
         PADDR    == {`ADDR_WIDTH{1'b1}};
      });

      mbx_gd.put(trans);

   endtask



   task random_test();

      repeat(num_trans) begin

         trans = new();

         assert(trans.randomize());

         mbx_gd.put(trans);

      end

   endtask



   task wait_state_test();

      repeat(num_trans) begin

         trans = new();

         assert(trans.randomize() with {
            PSEL     == 1;
            PENABLE  == 1;
         });

         mbx_gd.put(trans);

      end

   endtask



   task error_test();

      repeat(num_trans) begin

         trans = new();

         assert(trans.randomize() with {
            PSEL     == 1;
            PENABLE  == 1;
            PADDR inside {'h0,{`ADDR_WIDTH{1'b1}}};
         });

         mbx_gd.put(trans);

      end

   endtask



   task strobe_test();

      bit [(`DATA_WIDTH/8)-1:0] strobe[$] = '{
         4'b0001,
         4'b0010,
         4'b0100,
         4'b1000,
         4'b0011,
         4'b1100,
         4'b1111
      };

      foreach(strobe[i]) begin

         trans = new();

         assert(trans.randomize() with {
            PSEL     == 1;
            PENABLE  == 1;
            PWRITE   == 1;
            PSTRB    == strobe[i];
         });

         mbx_gd.put(trans);

      end

   endtask

endclass
