// cla64_hier.v
// BONUS -- open-ended. No detailed scaffold is provided; this is meant to
// be a genuine design exercise. Not required for lab submission.
//
// You will likely need to modify cla4.v (or add signals alongside it) so
// that block-generate/block-propagate summaries of its own Gi, Pi signals
// are exposed as outputs, since the second-level lookahead unit below
// needs them. As with every module in this lab from Task 2 onward, every
// gate/assign you add should carry an explicit delay.
//
// Starting point (from Tutorial 3, Q4(d)):
//   - Reuse 16 four-bit CLA blocks (your cla4.v) -- their internal logic
//     doesn't change.
//   - For each block k, define:
//       Gblk_k = "this block produces a carry regardless of its incoming
//                 carry" -- a Boolean function of that block's own 4
//                 bit-level Gi, Pi signals.
//       Pblk_k = "an incoming carry sails straight through this whole
//                 block" -- likewise a function of its own Gi, Pi.
//   - Build a second-level lookahead unit -- structurally identical to
//     cla4.v, just one level up -- that computes each block's carry-in
//     directly from Gblk_0..Gblk_15, Pblk_0..Pblk_15, and cin, instead of
//     rippling block to block.
//
// To test this, wire it into dut.v as a fourth option (copy the pattern
// used for the other three) and run it through the same tb.v. Compare
// your final delay to cla64_blocked.v from Task 4.

module cla64_hier(
  input  [63:0] a,
  input  [63:0] b,
  input         cin,
  output [63:0] sum,
  output        cout
);

  // Each element represents one four-bit CLA block.  block_carry[k] is
  // the carry into block k (and block_carry[16] is the final carry-out).
  wire [15:0] gblk;
  wire [15:0] pblk;
  wire [16:0] block_carry;

  // The level-two lookahead.  These equations deliberately use cin and
  // the block summaries directly; they do not ripple from one block to
  // the next.  The #2 on each assign models the delay of this level.
  assign #(2) block_carry[0]  = cin;
  assign #(2) block_carry[1]  = gblk[0] |
                                (pblk[0] & cin);
  assign #(2) block_carry[2]  = gblk[1] |
                                (pblk[1] & gblk[0]) |
                                (pblk[1] & pblk[0] & cin);
  assign #(2) block_carry[3]  = gblk[2] |
                                (pblk[2] & gblk[1]) |
                                (pblk[2] & pblk[1] & gblk[0]) |
                                (pblk[2] & pblk[1] & pblk[0] & cin);
  assign #(2) block_carry[4]  = gblk[3] | (pblk[3] & gblk[2]) |
                                (pblk[3] & pblk[2] & gblk[1]) |
                                (pblk[3] & pblk[2] & pblk[1] & gblk[0]) |
                                (pblk[3] & pblk[2] & pblk[1] & pblk[0] & cin);
  assign #(2) block_carry[5]  = gblk[4] | (pblk[4] & gblk[3]) | (pblk[4] & pblk[3] & gblk[2]) | (pblk[4] & pblk[3] & pblk[2] & gblk[1]) | (pblk[4] & pblk[3] & pblk[2] & pblk[1] & gblk[0]) | (pblk[4] & pblk[3] & pblk[2] & pblk[1] & pblk[0] & cin);
  assign #(2) block_carry[6]  = gblk[5] | (pblk[5] & gblk[4]) | (pblk[5] & pblk[4] & gblk[3]) | (pblk[5] & pblk[4] & pblk[3] & gblk[2]) | (pblk[5] & pblk[4] & pblk[3] & pblk[2] & gblk[1]) | (pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & gblk[0]) | (pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & pblk[0] & cin);
  assign #(2) block_carry[7]  = gblk[6] | (pblk[6] & gblk[5]) | (pblk[6] & pblk[5] & gblk[4]) | (pblk[6] & pblk[5] & pblk[4] & gblk[3]) | (pblk[6] & pblk[5] & pblk[4] & pblk[3] & gblk[2]) | (pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & gblk[1]) | (pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & gblk[0]) | (pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & pblk[0] & cin);
  assign #(2) block_carry[8]  = gblk[7] | (pblk[7] & gblk[6]) | (pblk[7] & pblk[6] & gblk[5]) | (pblk[7] & pblk[6] & pblk[5] & gblk[4]) | (pblk[7] & pblk[6] & pblk[5] & pblk[4] & gblk[3]) | (pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & gblk[2]) | (pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & gblk[1]) | (pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & gblk[0]) | (pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & pblk[0] & cin);
  assign #(2) block_carry[9]  = gblk[8] | (pblk[8] & gblk[7]) | (pblk[8] & pblk[7] & gblk[6]) | (pblk[8] & pblk[7] & pblk[6] & gblk[5]) | (pblk[8] & pblk[7] & pblk[6] & pblk[5] & gblk[4]) | (pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & gblk[3]) | (pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & gblk[2]) | (pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & gblk[1]) | (pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & gblk[0]) | (pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & pblk[0] & cin);
  assign #(2) block_carry[10] = gblk[9] | (pblk[9] & gblk[8]) | (pblk[9] & pblk[8] & gblk[7]) | (pblk[9] & pblk[8] & pblk[7] & gblk[6]) | (pblk[9] & pblk[8] & pblk[7] & pblk[6] & gblk[5]) | (pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & gblk[4]) | (pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & gblk[3]) | (pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & gblk[2]) | (pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & gblk[1]) | (pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & gblk[0]) | (pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & pblk[0] & cin);
  assign #(2) block_carry[11] = gblk[10] | (pblk[10] & gblk[9]) | (pblk[10] & pblk[9] & gblk[8]) | (pblk[10] & pblk[9] & pblk[8] & gblk[7]) | (pblk[10] & pblk[9] & pblk[8] & pblk[7] & gblk[6]) | (pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & gblk[5]) | (pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & gblk[4]) | (pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & gblk[3]) | (pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & gblk[2]) | (pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & gblk[1]) | (pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & gblk[0]) | (pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & pblk[0] & cin);
  assign #(2) block_carry[12] = gblk[11] | (pblk[11] & gblk[10]) | (pblk[11] & pblk[10] & gblk[9]) | (pblk[11] & pblk[10] & pblk[9] & gblk[8]) | (pblk[11] & pblk[10] & pblk[9] & pblk[8] & gblk[7]) | (pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & gblk[6]) | (pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & gblk[5]) | (pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & gblk[4]) | (pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & gblk[3]) | (pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & gblk[2]) | (pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & gblk[1]) | (pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & gblk[0]) | (pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & pblk[0] & cin);
  assign #(2) block_carry[13] = gblk[12] | (pblk[12] & gblk[11]) | (pblk[12] & pblk[11] & gblk[10]) | (pblk[12] & pblk[11] & pblk[10] & gblk[9]) | (pblk[12] & pblk[11] & pblk[10] & pblk[9] & gblk[8]) | (pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & gblk[7]) | (pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & gblk[6]) | (pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & gblk[5]) | (pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & gblk[4]) | (pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & gblk[3]) | (pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & gblk[2]) | (pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & gblk[1]) | (pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & gblk[0]) | (pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & pblk[0] & cin);
  assign #(2) block_carry[14] = gblk[13] | (pblk[13] & gblk[12]) | (pblk[13] & pblk[12] & gblk[11]) | (pblk[13] & pblk[12] & pblk[11] & gblk[10]) | (pblk[13] & pblk[12] & pblk[11] & pblk[10] & gblk[9]) | (pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & gblk[8]) | (pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & gblk[7]) | (pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & gblk[6]) | (pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & gblk[5]) | (pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & gblk[4]) | (pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & gblk[3]) | (pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & gblk[2]) | (pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & gblk[1]) | (pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & gblk[0]) | (pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & pblk[0] & cin);
  assign #(2) block_carry[15] = gblk[14] | (pblk[14] & gblk[13]) | (pblk[14] & pblk[13] & gblk[12]) | (pblk[14] & pblk[13] & pblk[12] & gblk[11]) | (pblk[14] & pblk[13] & pblk[12] & pblk[11] & gblk[10]) | (pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & gblk[9]) | (pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & gblk[8]) | (pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & gblk[7]) | (pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & gblk[6]) | (pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & gblk[5]) | (pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & gblk[4]) | (pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & gblk[3]) | (pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & gblk[2]) | (pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & gblk[1]) | (pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & gblk[0]) | (pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & pblk[0] & cin);
  assign #(2) block_carry[16] = gblk[15] | (pblk[15] & gblk[14]) | (pblk[15] & pblk[14] & gblk[13]) | (pblk[15] & pblk[14] & pblk[13] & gblk[12]) | (pblk[15] & pblk[14] & pblk[13] & pblk[12] & gblk[11]) | (pblk[15] & pblk[14] & pblk[13] & pblk[12] & pblk[11] & gblk[10]) | (pblk[15] & pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & gblk[9]) | (pblk[15] & pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & gblk[8]) | (pblk[15] & pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & gblk[7]) | (pblk[15] & pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & gblk[6]) | (pblk[15] & pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & gblk[5]) | (pblk[15] & pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & gblk[4]) | (pblk[15] & pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & gblk[3]) | (pblk[15] & pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & gblk[2]) | (pblk[15] & pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & gblk[1]) | (pblk[15] & pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & gblk[0]) | (pblk[15] & pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & pblk[0] & cin);

  genvar k;
  generate
    for (k = 0; k < 16; k = k + 1) begin : gen_cla4_blocks
      cla4 block (
        .a   (a[k*4 +: 4]),
        .b   (b[k*4 +: 4]),
        .cin (block_carry[k]),
        .sum (sum[k*4 +: 4]),
        .cout(),
        .Gblk(gblk[k]),
        .Pblk(pblk[k])
      );
    end
  endgenerate

  assign #(2) cout = block_carry[16];

endmodule