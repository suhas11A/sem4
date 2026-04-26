//
// This code is adapted from the MIT 6.828 lab materials:
// https://pdos.csail.mit.edu/6.828/2025/labs/net.html
// Copyright (c) The Regents of the Massachusetts Institute of Technology.
//

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"
#include "e1000_dev.h"

#define TX_RING_SIZE 16
static struct tx_desc tx_ring[TX_RING_SIZE] __attribute__((aligned(16)));

#define RX_RING_SIZE 16
static struct rx_desc rx_ring[RX_RING_SIZE] __attribute__((aligned(16)));

// remember where the e1000's registers live.
static volatile uint32 *regs;

struct spinlock e1000_lock;

//
// For TASK 3
//
#define upstatus(status) ((status & (1 << 1)) ? "up" : "down")
#define speed(status) ((status & (7 << 6)) ? 1000 : 100)
#define duplex(status) ((status & (1 << 0)) ? "full" : "half")

//
// For TASK 4
//
// Peek to find current tail index
#define CURR_TX_IDX regs[E1000_TDT]
// Calculate the next tail index for queuing next packet in ring
#define NEXT_TX_IDX(idx, size) (((idx) + 1) % (size))
// Check if tx at index is done (returns 0 if done)
#define TX_DONE(tx_ring, idx) ((tx_ring[idx].status) & E1000_TXD_STAT_DD)
// Status value to notify packet to be sent
#define TX_SEND 0
// Command value to notify packet to be sent
#define TX_CMD_FLAGS (E1000_TXD_CMD_EOP | E1000_TXD_CMD_RS)

//
// For TASK 5
//
// Peek to find current tail index
#define CURR_RX_IDX regs[E1000_RDT]
// Calculate the next tail index for queuing next packet in ring
#define NEXT_RX_IDX(idx, size) (((idx) + 1) % (size))
// Check if packet are available at index (returns 0 if not available)
#define RX_AVAILABLE(rx_ring, idx) ((rx_ring[idx].status) & E1000_RXD_STAT_DD)
// Status value to notify packet is processed
#define RX_CLEAR 0

// called by pci_init().
// xregs is the memory address at which the
// e1000's registers are mapped.
// this code loosely follows the initialization directions
// in Chapter 14 of Intel's Software Developer's Manual.
void
e1000_init(uint32 *xregs)
{
  int i;

  initlock(&e1000_lock, "e1000");

  regs = xregs;

  // Reset the device
  regs[E1000_IMS] = 0; // disable interrupts
  regs[E1000_CTL] |= E1000_CTL_RST;
  regs[E1000_IMS] = 0; // redisable interrupts
  __sync_synchronize();

  // [E1000 14.5] Transmit initialization
  memset(tx_ring, 0, sizeof(tx_ring));
  for (i = 0; i < TX_RING_SIZE; i++) {
    tx_ring[i].status = E1000_TXD_STAT_DD;
    tx_ring[i].addr = 0;
  }
  regs[E1000_TDBAL] = (uint64) tx_ring;
  if(sizeof(tx_ring) % 128 != 0)
    panic("e1000");
  regs[E1000_TDLEN] = sizeof(tx_ring);
  regs[E1000_TDH] = regs[E1000_TDT] = 0;
  
  // [E1000 14.4] Receive initialization
  memset(rx_ring, 0, sizeof(rx_ring));
  for (i = 0; i < RX_RING_SIZE; i++) {
    rx_ring[i].addr = (uint64) kalloc();
    if (!rx_ring[i].addr)
      panic("e1000");
  }
  regs[E1000_RDBAL] = (uint64) rx_ring;
  if(sizeof(rx_ring) % 128 != 0)
    panic("e1000");
  regs[E1000_RDH] = 0;
  regs[E1000_RDT] = RX_RING_SIZE - 1;
  regs[E1000_RDLEN] = sizeof(rx_ring);

  // filter by qemu's MAC address, 52:54:00:12:34:56
  regs[E1000_RA] = 0x12005452;
  regs[E1000_RA+1] = 0x5634 | (1<<31);
  // multicast table
  for (int i = 0; i < 4096/32; i++)
    regs[E1000_MTA + i] = 0;

  // transmitter control bits.
  regs[E1000_TCTL] = E1000_TCTL_EN |  // enable
    E1000_TCTL_PSP |                  // pad short packets
    (0x10 << E1000_TCTL_CT_SHIFT) |   // collision stuff
    (0x40 << E1000_TCTL_COLD_SHIFT);
  regs[E1000_TIPG] = 10 | (8<<10) | (6<<20); // inter-pkt gap

  // receiver control bits.
  regs[E1000_RCTL] = E1000_RCTL_EN | // enable receiver
    E1000_RCTL_BAM |                 // enable broadcast
    E1000_RCTL_SZ_2048 |             // 2048-byte rx buffers
    E1000_RCTL_SECRC;                // strip CRC
  
  // ask e1000 for receive interrupts.
  regs[E1000_RDTR] = 0; // interrupt after every received packet (no timer)
  regs[E1000_RADV] = 0; // interrupt after every packet (no timer)
  regs[E1000_IMS] = (1 << 7); // RXDW -- Receiver Descriptor Write Back
}

int
e1000_transmit(char *buf, int len)
{
  //
  // TASK 4
  // Your code here.
  //
  // buf contains an ethernet frame; program it into
  // the TX descriptor ring so that the e1000 sends it. Stash
  // a pointer so that it can be freed after send completes.
  //
  // return 0 on success.
  // return -1 on failure (e.g., there is no descriptor available)
  // so that the caller knows to free buf.
  //
  
  return 0;
}

static void
e1000_recv(void)
{
  //
  // TASK 5
  // Your code here.
  //
  // Check for packets that have arrived from the e1000
  // Create and deliver a buf for each packet (using net_rx()).
  //
  int idx;
  //
  // add more code here
  //

  idx = CURR_RX_IDX;
  idx = NEXT_RX_IDX(idx, RX_RING_SIZE);
  while (RX_AVAILABLE(rx_ring, idx)) {
    //
    // add more code here
    //
  }

}

void
e1000_intr(void)
{
  // tell the e1000 we've seen this interrupt;
  // without this the e1000 won't raise any
  // further interrupts.
  regs[E1000_ICR] = 0xffffffff;

  e1000_recv();
}

//
// For TASK 3
//
void
e1000_status(void)
{
  //
  // TASK 3
  // Your code here.
  //
  // read the e1000's status register and use the 
  // upstatus(), speed(), and duplex() functions 
  // to print out the link status, speed, and 
  // duplex mode of the e1000.
  //
  // print syntax
  // printf("\nLink %s, Speed %dMbps, %s duplex\n", ..)



}
