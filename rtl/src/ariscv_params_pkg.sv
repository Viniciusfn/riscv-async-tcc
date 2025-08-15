package ariscv_params_pkg;

   typedef struct packed {
      /* PARAMETERS */
      int NBW_ACLK;
      // CTRLPATH
         // Delays: DELAY_Source_Receiver
      int DELAY_PC_FD;
      int DELAY_FD_DE;
      int DELAY_DE_EM;
      int DELAY_DE_PC;
      int DELAY_EM_MW;
      int DELAY_MW_REG;
      int DELAY_REG_DE;
      int DELAY_LOOP;
         // Initialization
      bit INIT_PC;
      bit INIT_FD;
      bit INIT_DE;
      bit INIT_EM;
      bit INIT_MW;
      bit INIT_REG;
      bit INIT_LOOP1;
      bit INIT_LOOP2;

      // DTPATH
      int NBW_INST;
      int NBW_REGISTER;
      int NBW_ADDR;
      int NBW_PC;
   } ariscv_params_t;

   localparam ariscv_params_t ARISCV_PARAMS = '{
      /* PARAMETERS */
      NBW_ACLK       : 6,
      // CTRLPATH
         // Delays: DELAY_Source_Receiver
      DELAY_PC_FD    : 16,
      DELAY_FD_DE    : 28,
      DELAY_DE_EM    : 38,
      DELAY_DE_PC    : 38,
      DELAY_EM_MW    : 28,
      DELAY_MW_REG   : 38,
      DELAY_REG_DE   : 28,
      DELAY_LOOP     : 1,
         // Initialization
      INIT_PC        : 0,
      INIT_FD        : 0,
      INIT_DE        : 1,
      INIT_EM        : 0,
      INIT_MW        : 0,
      INIT_REG       : 1,
      INIT_LOOP1     : 0,
      INIT_LOOP2     : 1,

      // DTPATH
      NBW_INST       : 32,
      NBW_REGISTER   : 32,
      NBW_ADDR       : 5,
      NBW_PC         : 32
   };

endpackage
