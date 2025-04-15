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
      int INIT_PC;
      int INIT_FD;
      int INIT_DE;
      int INIT_EM;
      int INIT_MW;
      int INIT_REG;
      int INIT_LOOP1;
      int INIT_LOOP2;

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
      DELAY_PC_FD    : 1,
      DELAY_FD_DE    : 1,
      DELAY_DE_EM    : 1,
      DELAY_DE_PC    : 1,
      DELAY_EM_MW    : 1,
      DELAY_MW_REG   : 1,
      DELAY_REG_DE   : 1,
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
      NBW_ADDR       : 32,
      NBW_PC         : 32
   };

endpackage
