
rv32i_selftest.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00500093          	li	ra,5
   4:	00300113          	li	sp,3
   8:	002081b3          	add	gp,ra,sp
   c:	00800413          	li	s0,8
  10:	1c819a63          	bne	gp,s0,1e4 <fail>
  14:	40208233          	sub	tp,ra,sp
  18:	00200493          	li	s1,2
  1c:	1c921463          	bne	tp,s1,1e4 <fail>
  20:	00100513          	li	a0,1
  24:	00a112b3          	sll	t0,sp,a0
  28:	00600593          	li	a1,6
  2c:	1ab29c63          	bne	t0,a1,1e4 <fail>
  30:	00112633          	slt	a2,sp,ra
  34:	00100693          	li	a3,1
  38:	1ad61663          	bne	a2,a3,1e4 <fail>
  3c:	fff00313          	li	t1,-1
  40:	0060b733          	sltu	a4,ra,t1
  44:	00100793          	li	a5,1
  48:	18f71e63          	bne	a4,a5,1e4 <fail>
  4c:	0020c833          	xor	a6,ra,sp
  50:	00600893          	li	a7,6
  54:	19181863          	bne	a6,a7,1e4 <fail>
  58:	002081b3          	add	gp,ra,sp
  5c:	00100b13          	li	s6,1
  60:	0161dbb3          	srl	s7,gp,s6
  64:	00400c13          	li	s8,4
  68:	178b9e63          	bne	s7,s8,1e4 <fail>
  6c:	ff800c93          	li	s9,-8
  70:	416cdd33          	sra	s10,s9,s6
  74:	ffc00d93          	li	s11,-4
  78:	17bd1663          	bne	s10,s11,1e4 <fail>
  7c:	0020e933          	or	s2,ra,sp
  80:	00700993          	li	s3,7
  84:	17391063          	bne	s2,s3,1e4 <fail>
  88:	0020fa33          	and	s4,ra,sp
  8c:	00100a93          	li	s5,1
  90:	155a1a63          	bne	s4,s5,1e4 <fail>
  94:	00a08293          	addi	t0,ra,10
  98:	00f00313          	li	t1,15
  9c:	14629463          	bne	t0,t1,1e4 <fail>
  a0:	ffd0a293          	slti	t0,ra,-3
  a4:	00028463          	beqz	t0,ac <_start+0xac>
  a8:	13c0006f          	j	1e4 <fail>
  ac:	00103293          	seqz	t0,zero
  b0:	00100313          	li	t1,1
  b4:	12629863          	bne	t0,t1,1e4 <fail>
  b8:	0ff0c293          	xori	t0,ra,255
  bc:	0fa00313          	li	t1,250
  c0:	12629263          	bne	t0,t1,1e4 <fail>
  c4:	10006293          	ori	t0,zero,256
  c8:	10000313          	li	t1,256
  cc:	10629c63          	bne	t0,t1,1e4 <fail>
  d0:	0069f293          	andi	t0,s3,6
  d4:	00600313          	li	t1,6
  d8:	10629663          	bne	t0,t1,1e4 <fail>
  dc:	00209313          	slli	t1,ra,0x2
  e0:	01400393          	li	t2,20
  e4:	10731063          	bne	t1,t2,1e4 <fail>
  e8:	0013d313          	srli	t1,t2,0x1
  ec:	00a00393          	li	t2,10
  f0:	0e731a63          	bne	t1,t2,1e4 <fail>
  f4:	ff800313          	li	t1,-8
  f8:	40135313          	srai	t1,t1,0x1
  fc:	ffc00393          	li	t2,-4
 100:	0e731263          	bne	t1,t2,1e4 <fail>
 104:	00000517          	auipc	a0,0x0
 108:	0fc50513          	addi	a0,a0,252 # 200 <data_area>
 10c:	89abd5b7          	lui	a1,0x89abd
 110:	def58593          	addi	a1,a1,-529 # 89abcdef <__global_pointer$+0x89abb3db>
 114:	00b52023          	sw	a1,0(a0)
 118:	00052603          	lw	a2,0(a0)
 11c:	0cc59463          	bne	a1,a2,1e4 <fail>
 120:	123455b7          	lui	a1,0x12345
 124:	67858593          	addi	a1,a1,1656 # 12345678 <__global_pointer$+0x12343c64>
 128:	00b52223          	sw	a1,4(a0)
 12c:	00451603          	lh	a2,4(a0)
 130:	000056b7          	lui	a3,0x5
 134:	67868693          	addi	a3,a3,1656 # 5678 <__global_pointer$+0x3c64>
 138:	0ad61663          	bne	a2,a3,1e4 <fail>
 13c:	00550603          	lb	a2,5(a0)
 140:	05600693          	li	a3,86
 144:	0ad61063          	bne	a2,a3,1e4 <fail>
 148:	00455603          	lhu	a2,4(a0)
 14c:	000056b7          	lui	a3,0x5
 150:	67868693          	addi	a3,a3,1656 # 5678 <__global_pointer$+0x3c64>
 154:	08d61863          	bne	a2,a3,1e4 <fail>
 158:	00754603          	lbu	a2,7(a0)
 15c:	01200693          	li	a3,18
 160:	08d61263          	bne	a2,a3,1e4 <fail>
 164:	00a00093          	li	ra,10
 168:	00a00113          	li	sp,10
 16c:	00208463          	beq	ra,sp,174 <_start+0x174>
 170:	0740006f          	j	1e4 <fail>
 174:	06209863          	bne	ra,sp,1e4 <fail>
 178:	fff00093          	li	ra,-1
 17c:	00100113          	li	sp,1
 180:	0020c463          	blt	ra,sp,188 <_start+0x188>
 184:	0600006f          	j	1e4 <fail>
 188:	00115463          	bge	sp,ra,190 <_start+0x190>
 18c:	0580006f          	j	1e4 <fail>
 190:	0420ea63          	bltu	ra,sp,1e4 <fail>
 194:	0020f463          	bgeu	ra,sp,19c <_start+0x19c>
 198:	04c0006f          	j	1e4 <fail>
 19c:	00000097          	auipc	ra,0x0
 1a0:	01008093          	addi	ra,ra,16 # 1ac <after_call>
 1a4:	0540016f          	jal	sp,1f8 <subroutine>
 1a8:	03c0006f          	j	1e4 <fail>

000001ac <after_call>:
 1ac:	00000297          	auipc	t0,0x0
 1b0:	00000317          	auipc	t1,0x0
 1b4:	00428293          	addi	t0,t0,4 # 1b0 <after_call+0x4>
 1b8:	02629663          	bne	t0,t1,1e4 <fail>
 1bc:	12300293          	li	t0,291
 1c0:	00829293          	slli	t0,t0,0x8
 1c4:	04528293          	addi	t0,t0,69
 1c8:	00c29293          	slli	t0,t0,0xc
 1cc:	12345337          	lui	t1,0x12345
 1d0:	00531a63          	bne	t1,t0,1e4 <fail>

000001d4 <pass>:
 1d4:	00100093          	li	ra,1
 1d8:	00010137          	lui	sp,0x10
 1dc:	00112023          	sw	ra,0(sp) # 10000 <__global_pointer$+0xe5ec>
 1e0:	01c0006f          	j	1fc <done>

000001e4 <fail>:
 1e4:	0000e0b7          	lui	ra,0xe
 1e8:	ead08093          	addi	ra,ra,-339 # dead <__global_pointer$+0xc499>
 1ec:	00010137          	lui	sp,0x10
 1f0:	00112023          	sw	ra,0(sp) # 10000 <__global_pointer$+0xe5ec>
 1f4:	0080006f          	j	1fc <done>

000001f8 <subroutine>:
 1f8:	00008067          	ret

000001fc <done>:
 1fc:	0000006f          	j	1fc <done>

00000200 <data_area>:
	...
 210:	00000013          	nop
