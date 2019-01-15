	.section	__TEXT,__text,regular,pure_instructions
	.macosx_version_min 10, 13
	.globl	_main                   ## -- Begin function main
	.p2align	4, 0x90
_main:                                  ## @main
## BB#0:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%eax
	calll	L0$pb
L0$pb:
	popl	%eax
	movl	$655360, %ecx           ## imm = 0xA0000
	movl	%ecx, -4(%ebp)
	movl	-4(%ebp), %ecx
	movl	_screen_x-L0$pb(%eax), %eax
	movb	$15, (%ecx,%eax)
	addl	$4, %esp
	popl	%ebp
	retl
                                        ## -- End function
	.globl	_set_pixel              ## -- Begin function set_pixel
	.p2align	4, 0x90
_set_pixel:                             ## @set_pixel
## BB#0:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	pushl	%edi
	pushl	%esi
	subl	$16, %esp
	movb	20(%ebp), %al
	movl	16(%ebp), %ecx
	movl	12(%ebp), %edx
	movl	8(%ebp), %esi
	movb	20(%ebp), %ah
	movl	8(%ebp), %edi
	imull	$320, 16(%ebp), %ebx    ## imm = 0x140
	addl	12(%ebp), %ebx
	movb	%ah, (%edi,%ebx)
	movb	%al, -13(%ebp)          ## 1-byte Spill
	movl	%ecx, -20(%ebp)         ## 4-byte Spill
	movl	%edx, -24(%ebp)         ## 4-byte Spill
	movl	%esi, -28(%ebp)         ## 4-byte Spill
	addl	$16, %esp
	popl	%esi
	popl	%edi
	popl	%ebx
	popl	%ebp
	retl
                                        ## -- End function
	.globl	_screen_x               ## @screen_x
.zerofill __DATA,__common,_screen_x,4,2
	.section	__DATA,__data
	.globl	_screen_y               ## @screen_y
	.p2align	2
_screen_y:
	.long	2                       ## 0x2


.subsections_via_symbols
