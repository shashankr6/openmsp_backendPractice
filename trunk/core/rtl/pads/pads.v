`timescale 1ns/1ps
`include "../../rtl/verilog/openMSP430_defines.v"

module pads (
    // Module outputs going out via pad	
    output               aclk,                   // ASIC ONLY: ACLK
    output               aclk_en,                // FPGA ONLY: ACLK enable
    output               dbg_freeze,             // Freeze peripherals
    output               dbg_i2c_sda_out,       // Debug interface: I2C SDA OUT
    output               dbg_uart_txd,           // Debug interface: UART TXD	
    output               dco_enable,             // ASIC ONLY: Fast oscillator enable
    output               dco_wkup,               // ASIC ONLY: Fast oscillator wake-up (asynchronous)
    output [`DMEM_MSB:0] dmem_addr,              // Data Memory address
    output               dmem_cen,               // Data Memory chip enable (low active)
    output        [15:0] dmem_din,               // Data Memory data     input
    output         [1:0] dmem_wen,               // Data Memory write byte enable (low active)
    output [`IRQ_NR-3:0] irq_acc,                // Interrupt request accepted (one-hot signal)
    output               lfxt_enable,            // ASIC ONLY: Low frequency oscillator enable
    output               lfxt_wkup,              // ASIC ONLY: Low frequency oscillator wake-up (asynchronous)
    output               mclk,                   // Main system clock
    output        [15:0] dma_dout,               // Direct Memory Access data     output
    output               dma_ready,              // Direct Memory Access is complete
    output               dma_resp,               // Direct Memory Access response (0:Okay / 1:Error)
    output        [13:0] per_addr,               // Peripheral address
    output        [15:0] per_din,                // Peripheral data input
    output               per_en,                 // Peripheral enable (high active)
    output         [1:0] per_we,                 // Peripheral write byte enable (high active)
    output [`PMEM_MSB:0] pmem_addr,              // Program Memory address
    output               pmem_cen,               // Program Memory chip enable (low active)
    output        [15:0] pmem_din,               // Program Memory data input (optional)
    output         [1:0] pmem_wen,               // Program Memory write enable (low active) (optional)
    output               puc_rst,               // Main system reset
    output               smclk,                  // ASIC ONLY: SMCLK
    output               smclk_en,               // FPGA ONLY: SMCLK enable
    
    // Design inputs coming to pad first	
    input                cpu_en,                 // Enable CPU code execution (asynchronous and non-glitchy)
    input                dbg_en,                 // Debug interface enable (asynchronous and non-glitchy)
    input          [6:0] dbg_i2c_addr,           // Debug interface: I2C Address
    input          [6:0] dbg_i2c_broadcast,      // Debug interface: I2C Broadcast Address (for multicore systems)
    input                dbg_i2c_scl,            // Debug interface: I2C SCL
    input                dbg_i2c_sda_in,         // Debug interface: I2C SDA IN	
    input                dbg_uart_rxd,           // Debug interface: UART RXD (asynchronous)
    input                dco_clk,                // Fast oscillator (fast clock)
    input         [15:0] dmem_dout,              // Data Memory data output
    input  [`IRQ_NR-3:0] irq,                    // Maskable interrupts (14, 30 or 62)
    input                lfxt_clk,               // Low frequency oscillator (typ 32kHz)
    input         [15:1] dma_addr,               // Direct Memory Access address
    input         [15:0] dma_din,                // Direct Memory Access data     input
    input                dma_en,                 // Direct Memory Access enable (high active)
    input                dma_priority,           // Direct Memory Access priority (0:low / 1:high)
    input          [1:0] dma_we,                 // Direct Memory Access write byte enable (high active)
    input                dma_wkup,               // ASIC ONLY: DMA Wake-up (asynchronous and non-glitchy)
    input                nmi,                    // Non-maskable interrupt (asynchronous and non-glitchy)
    input         [15:0] per_dout,               // Peripheral data output
    input         [15:0] pmem_dout,              // Program Memory data output
    input                reset_n,                // Reset Pin (active low, asynchronous and non-glitchy)
    input                scan_enable,            // ASIC ONLY: Scan enable (active during scan shifting)
    input                scan_mode,              // ASIC ONLY: Scan mode
    input                wkup,                   // ASIC ONLY: System Wake-up (asynchronous and non-glitchy)

    // Design inputs coming out via pad
    output                cpu_en_p,                 // Enable CPU code execution (asynchronous and non-glitchy)
    output                dbg_en_p,                 // Debug interface enable (asynchronous and non-glitchy)
    output          [6:0] dbg_i2c_addr_p,           // Debug interface: I2C Address
    output          [6:0] dbg_i2c_broadcast_p,      // Debug interface: I2C Broadcast Address (for multicore systems)
    output                dbg_i2c_scl_p,            // Debug interface: I2C SCL
    output                dbg_i2c_sda_in_p,         // Debug interface: I2C SDA IN 
    output                dbg_uart_rxd_p,           // Debug interface: UART RXD (asynchronous)
    output                dco_clk_p,                // Fast oscillator (fast clock)
    output         [15:0] dmem_dout_p,              // Data Memory data output
    output  [`IRQ_NR-3:0] irq_p,                    // Maskable interrupts (14, 30 or 62)
    output                lfxt_clk_p,               // Low frequency oscillator (typ 32kHz)
    output         [15:1] dma_addr_p,               // Direct Memory Access address
    output         [15:0] dma_din_p,                // Direct Memory Access data input
    output                dma_en_p,                 // Direct Memory Access enable (high active)
    output                dma_priority_p,           // Direct Memory Access priority (0:low / 1:high)
    output          [1:0] dma_we_p,                 // Direct Memory Access write byte enable (high active)
    output                dma_wkup_p,               // ASIC ONLY: DMA Wake-up (asynchronous and non-glitchy)
    output                nmi_p,                    // Non-maskable interrupt (asynchronous and non-glitchy)
    output         [15:0] per_dout_p,               // Peripheral data output
    output         [15:0] pmem_dout_p,              // Program Memory data output
    output                reset_n_p,                // Reset Pin (active low, asynchronous and non-glitchy)
    output                scan_enable_p,            // ASIC ONLY: Scan enable (active during scan shifting)
    output                scan_mode_p,              // ASIC ONLY: Scan mode
    output                wkup_p,                   // ASIC ONLY: System Wake-up (asynchronous and non-glitchy)

    // Design outputs coming into pad
    input               aclk_p,                   // ASIC ONLY: ACLK
    input               aclk_en_p,                // FPGA ONLY: ACLK enable
    input               dbg_freeze_p,             // Freeze peripherals
    input               dbg_i2c_sda_out_p,        // Debug interface: I2C SDA OUT
    input               dbg_uart_txd_p,           // Debug interface: UART TXD
    input               dco_enable_p,             // ASIC ONLY: Fast oscillator enable
    input               dco_wkup_p,               // ASIC ONLY: Fast oscillator wake-up (asynchronous)
    input [`DMEM_MSB:0] dmem_addr_p,              // Data Memory address
    input               dmem_cen_p,               // Data Memory chip enable (low active)
    input        [15:0] dmem_din_p,               // Data Memory data input
    input         [1:0] dmem_wen_p,               // Data Memory write byte enable (low active)
    input [`IRQ_NR-3:0] irq_acc_p,                // Interrupt request accepted (one-hot signal)
    input               lfxt_enable_p,            // ASIC ONLY: Low frequency oscillator enable
    input               lfxt_wkup_p,              // ASIC ONLY: Low frequency oscillator wake-up (asynchronous)
    input               mclk_p,                   // Main system clock
    input        [15:0] dma_dout_p,               // Direct Memory Access data input
    input               dma_ready_p,              // Direct Memory Access is complete
    input               dma_resp_p,               // Direct Memory Access response (0:Okay / 1:Error)
    input        [13:0] per_addr_p,               // Peripheral address
    input        [15:0] per_din_p,                // Peripheral data input
    input               per_en_p,                 // Peripheral enable (high active)
    input         [1:0] per_we_p,                 // Peripheral write byte enable (high active)
    input [`PMEM_MSB:0] pmem_addr_p,              // Program Memory address
    input               pmem_cen_p,               // Program Memory chip enable (low active)
    input        [15:0] pmem_din_p,               // Program Memory data input (optional)
    input         [1:0] pmem_wen_p,               // Program Memory write enable (low active) (optional)
    input               puc_rst_p,                // Main system reset
    input               smclk_p,                  // ASIC ONLY: SMCLK
    input               smclk_en_p               // FPGA ONLY: SMCLK enable

);

parameter PADTECH = 0,
          PADLEVEL = 0,
          PADVOLTAGE = 0,
	  PADFILTER = 0,
          PADSTRENGTH = 0,
          PADSLEW = 0,
          PADCLKARCH = 0,
          PADHF = 0,
          SPW_INPUT_TYPE = 0,
          JTAG_PADFILTER = 0,
          TESTEN_PADFILTER = 0,
          RESETN_PADFILTER = 0,
          CLK_PADFILTER = 0,
          SPW_PADSTRENGTH = 0,
          JTAG_PADSTRENGTH = 0,
          UART_PADSTRENGTH = 0,
	  DSU_PADSTRENGTH = 0,
          OEPOL = 0;



outpad #(
		.tech (PADTECH),
		.level (PADLEVEL),
		.slew (PADSLEW),
		.voltage (PADVOLTAGE),
		.strength (PADSTRENGTH)
	) aclkPad (
		.pad(aclk),
		.i(aclk_p)
	);

outpad #(
		.tech (PADTECH),
		.level (PADLEVEL),
		.slew (PADSLEW),
		.voltage (PADVOLTAGE),
		.strength (PADSTRENGTH)
	) aclk_enPad (
		.pad(aclk_en),
		.i(aclk_en_p)
	);

outpad #(
		.tech (PADTECH),
		.level (PADLEVEL),
		.slew (PADSLEW),
		.voltage (PADVOLTAGE),
		.strength (PADSTRENGTH)
	) dbgFreezePad (
		.pad(dbg_freeze),
		.i(dbg_freeze_p)
	);

outpad #(
		.tech (PADTECH),
		.level (PADLEVEL),
		.slew (PADSLEW),
		.voltage (PADVOLTAGE),
		.strength (PADSTRENGTH)
	) dbg_i2c_sda_outPad (
		.pad(dbg_i2c_sda_out),
		.i(dbg_i2c_sda_out_p)
	);

outpad #(
		.tech (PADTECH),
		.level (PADLEVEL),
		.slew (PADSLEW),
		.voltage (PADVOLTAGE),
		.strength (PADSTRENGTH)
	) dbg_uart_txdPad (
		.pad(dbg_uart_txd),
		.i(dbg_uart_txd_p)
	);

outpad #(
		.tech (PADTECH),
		.level (PADLEVEL),
		.slew (PADSLEW),
		.voltage (PADVOLTAGE),
		.strength (PADSTRENGTH)
	) dcoEnablePad (
		.pad(dco_enable),
		.i(dco_enable_p)
	);

outpad #(
		.tech (PADTECH),
		.level (PADLEVEL),
		.slew (PADSLEW),
		.voltage (PADVOLTAGE),
		.strength (PADSTRENGTH)
	) dco_wkupPad (
		.pad(dco_wkup),
		.i(dco_wkup_p)
	);

outpad #(
		.tech (PADTECH),
		.level (PADLEVEL),
		.slew (PADSLEW),
		.voltage (PADVOLTAGE),
		.strength (PADSTRENGTH)
	) dmem_cen_Pad (
		.pad(dmem_cen),
		.i(dmem_cen_p)
	);

outpad #(
		.tech (PADTECH),
		.level (PADLEVEL),
		.slew (PADSLEW),
		.voltage (PADVOLTAGE),
		.strength (PADSTRENGTH)
	) lfxt_enablePad (
		.pad(lfxt_enable),
		.i(lfxt_enable_p)
	);

outpad #(
		.tech (PADTECH),
		.level (PADLEVEL),
		.slew (PADSLEW),
		.voltage (PADVOLTAGE),
		.strength (PADSTRENGTH)
	) lfxt_wkupPad (
		.pad(lfxt_wkup),
		.i(lfxt_wkup_p)
	);

outpad #(
		.tech (PADTECH),
		.level (PADLEVEL),
		.slew (PADSLEW),
		.voltage (PADVOLTAGE),
		.strength (PADSTRENGTH)
	) mclkPad (
		.pad(mclk),
		.i(mclk_p)
	);

outpad #(
		.tech (PADTECH),
		.level (PADLEVEL),
		.slew (PADSLEW),
		.voltage (PADVOLTAGE),
		.strength (PADSTRENGTH)
	) dma_readyPad  (
		.pad(dma_ready),
		.i(dma_ready_p)
	);

outpad #(
		.tech (PADTECH),
		.level (PADLEVEL),
		.slew (PADSLEW),
		.voltage (PADVOLTAGE),
		.strength (PADSTRENGTH)
	) dma_respPad (
		.pad(dma_resp),
		.i(dma_resp_p)
	);

outpad #(
		.tech (PADTECH),
		.level (PADLEVEL),
		.slew (PADSLEW),
		.voltage (PADVOLTAGE),
		.strength (PADSTRENGTH)
	) per_enPad (
		.pad(per_en),
		.i(per_en_p)
	);


outpad #(
		.tech (PADTECH),
		.level (PADLEVEL),
		.slew (PADSLEW),
		.voltage (PADVOLTAGE),
		.strength (PADSTRENGTH)
	) pmem_cenPad (
		.pad(pmem_cen),
		.i(pmem_cen_p)
	);

outpad #(
		.tech (PADTECH),
		.level (PADLEVEL),
		.slew (PADSLEW),
		.voltage (PADVOLTAGE),
		.strength (PADSTRENGTH)
	) puc_rstPad (
		.pad(puc_rst),
		.i(puc_rst_p)
	);

outpad #(
		.tech (PADTECH),
		.level (PADLEVEL),
		.slew (PADSLEW),
		.voltage (PADVOLTAGE),
		.strength (PADSTRENGTH)
	) smclkPad (
		.pad(smclk),
		.i(smclk_p)
	);

outpad #(
		.tech (PADTECH),
		.level (PADLEVEL),
		.slew (PADSLEW),
		.voltage (PADVOLTAGE),
		.strength (PADSTRENGTH)
	) smclk_enPad (
		.pad(smclk_en),
		.i(smclk_en_p)
	);


outpadv #(
		.width (`DMEM_MSB+1),
		.tech (PADTECH),
		.level (PADLEVEL),
		.slew (PADSLEW),
		.voltage (PADVOLTAGE),
		.strength (PADSTRENGTH)
	) dmemAddrPad (
		.pad (dmem_addr),
		.i (dmem_addr_p)
	);
	
outpadv #(
		.width (16),
		.tech (PADTECH),
		.level (PADLEVEL),
		.slew (PADSLEW),
		.voltage (PADVOLTAGE),
		.strength (PADSTRENGTH)
	) dmemdinPad (
		.pad (dmem_din),
		.i (dmem_din_p)
	);
	
outpadv #(
		.width (2),
		.tech (PADTECH),
		.level (PADLEVEL),
		.slew (PADSLEW),
		.voltage (PADVOLTAGE),
		.strength (PADSTRENGTH)
	) dmem_wenPad (
		.pad (dmem_wen),
		.i (dmem_wen_p)
	);
	
outpadv #(
		.width (`IRQ_NR-2),
		.tech (PADTECH),
		.level (PADLEVEL),
		.slew (PADSLEW),
		.voltage (PADVOLTAGE),
		.strength (PADSTRENGTH)
	) irq_accPad (
		.pad (irq_acc),
		.i (irq_acc_p)
	);
	
outpadv #(
		.width (16),
		.tech (PADTECH),
		.level (PADLEVEL),
		.slew (PADSLEW),
		.voltage (PADVOLTAGE),
		.strength (PADSTRENGTH)
	) dma_doutPad (
		.pad (dma_dout),
		.i (dma_dout_p)
	);
	
outpadv #(
		.width (14),
		.tech (PADTECH),
		.level (PADLEVEL),
		.slew (PADSLEW),
		.voltage (PADVOLTAGE),
		.strength (PADSTRENGTH)
	) per_addrPad (
		.pad (per_addr),
		.i (per_addr_p)
	);
	
outpadv #(
		.width (16),
		.tech (PADTECH),
		.level (PADLEVEL),
		.slew (PADSLEW),
		.voltage (PADVOLTAGE),
		.strength (PADSTRENGTH)
	) per_dinPad (
		.pad (per_din),
		.i (per_din_p)
	);
	
outpadv #(
		.width (2),
		.tech (PADTECH),
		.level (PADLEVEL),
		.slew (PADSLEW),
		.voltage (PADVOLTAGE),
		.strength (PADSTRENGTH)
	) per_wePad (
		.pad (per_we),
		.i (per_we_p)
	);
	
outpadv #(
		.width (`PMEM_MSB+1),
		.tech (PADTECH),
		.level (PADLEVEL),
		.slew (PADSLEW),
		.voltage (PADVOLTAGE),
		.strength (PADSTRENGTH)
	) pmem_addrPad (
		.pad (pmem_addr),
		.i (pmem_addr_p)
	);
	
outpadv  #(
		.width (16),
		.tech (PADTECH),
		.level (PADLEVEL),
		.slew (PADSLEW),
		.voltage (PADVOLTAGE),
		.strength (PADSTRENGTH)
	) pmem_dinPad (
		.pad (pmem_din),
		.i (pmem_din_p)
	);
	
outpadv #(
		.width (2),
		.tech (PADTECH),
		.level (PADLEVEL),
		.slew (PADSLEW),
		.voltage (PADVOLTAGE),
		.strength (PADSTRENGTH)
	) pmem_wenPad (
		.pad (pmem_wen),
		.i (pmem_wen_p)
	);
	

//===================================//

inpad  #(
		.tech (PADTECH),
		.level (PADLEVEL),
		.voltage (PADVOLTAGE),
		.filter (PADFILTER)
	) cpu_enPad (
		.pad (cpu_en),
		.o (cpu_en_p)
	);

inpad  #(
		.tech (PADTECH),
		.level (PADLEVEL),
		.voltage (PADVOLTAGE),
		.filter (PADFILTER)
	) dbg_enPad (
		.pad (dbg_en),
		.o (dbg_en_p)
	);

inpad  #(
		.tech (PADTECH),
		.level (PADLEVEL),
		.voltage (PADVOLTAGE),
		.filter (PADFILTER)
	) dbg_i2c_sclPad (
		.pad (dbg_i2c_scl),
		.o (dbg_i2c_scl_p)
	);

inpad  #(
		.tech (PADTECH),
		.level (PADLEVEL),
		.voltage (PADVOLTAGE),
		.filter (PADFILTER)
	) dbg_i2c_sda_inPad (
		.pad (dbg_i2c_sda_in),
		.o (dbg_i2c_sda_in_p)
	);

inpad  #(
		.tech (PADTECH),
		.level (PADLEVEL),
		.voltage (PADVOLTAGE),
		.filter (PADFILTER)
	) dbg_uart_rxdPad (
		.pad (dbg_uart_rxd),
		.o (dbg_uart_rxd_p)
	);

inpad  #(
		.tech (PADTECH),
		.level (PADLEVEL),
		.voltage (PADVOLTAGE),
		.filter (PADFILTER)
	) dma_enPad (
		.pad (dma_en),
		.o (dma_en_p)
	);

inpad  #(
		.tech (PADTECH),
		.level (PADLEVEL),
		.voltage (PADVOLTAGE),
		.filter (PADFILTER)
	) dma_priorityPad (
		.pad (dma_priority),
		.o (dma_priority_p)
	);

inpad  #(
		.tech (PADTECH),
		.level (PADLEVEL),
		.voltage (PADVOLTAGE),
		.filter (PADFILTER)
	) dma_wkupPad (
		.pad (dma_wkup),
		.o (dma_wkup_p)
	);

inpad  #(
		.tech (PADTECH),
		.level (PADLEVEL),
		.voltage (PADVOLTAGE),
		.filter (PADFILTER)
	) nmiPad (
		.pad (nmi),
		.o (nmi_p)
	);

inpad  #(
		.tech (PADTECH),
		.level (PADLEVEL),
		.voltage (PADVOLTAGE),
		.filter (PADFILTER)
	) reset_nPad (
		.pad (reset_n),
		.o (reset_n_p)
	);

inpad  #(
		.tech (PADTECH),
		.level (PADLEVEL),
		.voltage (PADVOLTAGE),
		.filter (PADFILTER)
	) scan_enablePad (
		.pad (scan_enable),
		.o (scan_enable_p)
	);

inpad  #(
		.tech (PADTECH),
		.level (PADLEVEL),
		.voltage (PADVOLTAGE),
		.filter (PADFILTER)
	) scan_modePad (
		.pad (scan_mode),
		.o (scan_mode_p)
	);


inpad  #(
		.tech (PADTECH),
		.level (PADLEVEL),
		.voltage (PADVOLTAGE),
		.filter (PADFILTER)
	) wkupPad (
		.pad (wkup),
		.o (wkup_p)
	);

inpadv #(
		.width (7),
		.tech (PADTECH),
		.level (PADLEVEL),
		.voltage (PADVOLTAGE),
		.filter (PADFILTER)		
	) dbg_i2c_addrPad (
		.pad (dbg_i2c_addr),
		.o (dbg_i2c_addr_p)
	);

inpadv #(
		.width (7),
		.tech (PADTECH),
		.level (PADLEVEL),
		.voltage (PADVOLTAGE),
		.filter (PADFILTER)		
	) dbg_i2c_broadcastPad (
		.pad (dbg_i2c_broadcast),
		.o (dbg_i2c_broadcast_p)
	);

inpadv #(
		.width (16),
		.tech (PADTECH),
		.level (PADLEVEL),
		.voltage (PADVOLTAGE),
		.filter (PADFILTER)		
	) dmem_doutPad (
		.pad (dmem_dout),
		.o (dmem_dout_p)
	);

inpadv #(
		.width (`IRQ_NR-2),
		.tech (PADTECH),
		.level (PADLEVEL),
		.voltage (PADVOLTAGE),
		.filter (PADFILTER)		
	) irqPad (
		.pad (irq),
		.o (irq_p)
	);

inpadv #(
		.width (15),
		.tech (PADTECH),
		.level (PADLEVEL),
		.voltage (PADVOLTAGE),
		.filter (PADFILTER)		
	) dma_addrPad (
		.pad (dma_addr),
		.o (dma_addr_p)
	);

inpadv #(
		.width (16),
		.tech (PADTECH),
		.level (PADLEVEL),
		.voltage (PADVOLTAGE),
		.filter (PADFILTER)		
	) dma_dinPad (
		.pad (dma_din),
		.o (dma_din_p)
	);

inpadv #(
		.width (2),
		.tech (PADTECH),
		.level (PADLEVEL),
		.voltage (PADVOLTAGE),
		.filter (PADFILTER)		
	) dma_wePad (
		.pad (dma_we),
		.o (dma_we_p)
	);

inpadv #(
		.width (16),
		.tech (PADTECH),
		.level (PADLEVEL),
		.voltage (PADVOLTAGE),
		.filter (PADFILTER)		
	) per_doutPad (
		.pad (per_dout),
		.o (per_dout_p)
	);

inpadv #(
		.width (16),
		.tech (PADTECH),
		.level (PADLEVEL),
		.voltage (PADVOLTAGE),
		.filter (PADFILTER)		
	) pmem_doutPad (
		.pad (pmem_dout),
		.o (pmem_dout_p)
	);

//====================================//
// clkpads

inpad #(
		.tech (PADTECH),
		.level (PADLEVEL),
		.voltage (PADVOLTAGE),
		.filter (PADFILTER)
	) dcoClkPad (
		.pad (dco_clk),
		.o (dco_clk_p)
	);

inpad #(
		.tech (PADTECH),
		.level (PADLEVEL),
		.voltage (PADVOLTAGE),
		.filter (PADFILTER)
	) lfxtClkPad (
		.pad (lfxt_clk),
		.o (lfxt_clk_p)
	);

endmodule	
