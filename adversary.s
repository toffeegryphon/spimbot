.text             
        PRINT_STRING = 4
        PRINT_CHAR = 11
        PRINT_INT = 1


        VELOCITY  = 0xffff0010
        ANGLE     = 0xffff0014
        ANGLE_CONTROL = 0xffff0018

        BOT_X     = 0xffff0020
        BOT_Y     = 0xffff0024

        OTHER_X   = 0xffff00a0
        OTHER_Y   = 0xffff00a4

        TIMER     = 0xffff001c

        REQUEST_PUZZLE = 0xffff00d0     ## Puzzle
        SUBMIT_SOLUTION = 0xffff00d4    ## Puzzle

        SCORES_REQUEST = 0xffff1018
        GET_MY_BULLETS = 0xffff2010
        GET_OP_BULLETS = 0xffff200c
        GET_MAP   = 0xffff2040

        CHARGE_SHOT = 0xffff2004
        SHOOT     = 0xffff2000

        BONK_INT_MASK = 0x1000          ## Bonk
        BONK_ACK  = 0xffff0060          ## Bonk

        TIMER_INT_MASK = 0x8000         ## Timer
        TIMER_ACK = 0xffff006c          ## Timer

        REQUEST_PUZZLE_INT_MASK = 0x800 ## Puzzle
        REQUEST_PUZZLE_ACK = 0xffff00d8 ## Puzzle

        RESPAWN_INT_MASK = 0x2000       ## Respawn
        RESPAWN_ACK = 0xffff00f0        ## Respawn


.data             
        interrupt_struct: .byte 0 0 0 0
.text             

        .align    2
        .globl    printInt
printInt:         
        move      $v1,$a0
        move      $a0, $v1
        li        $v0, 1
        syscall   
        j         $ra
        .align    2
        .globl    printChar
printChar:        
        move      $v1,$a0
        move      $a0, $v1
        li        $v0, 11
        syscall   
        j         $ra
        .align    2
        .globl    printString
printString:      
        move      $v1,$a0
        move      $a0, $v1
        li        $v0, PRINT_STRING
        syscall   
        j         $ra
        .align    2
        .globl    rng
rng:              
        la        $a0,rng_state
        lw        $v0,0($a0)
        sll       $v1,$v0,13
        xor       $v1,$v1,$v0
        srl       $v0,$v1,17
        xor       $v1,$v0,$v1
        sll       $v0,$v1,5
        xor       $v0,$v0,$v1
        sw        $v0,0($a0)
        j         $ra
        .align    2
        .globl    setVelocity
setVelocity:      
        sw        $a0, VELOCITY

        j         $ra
        .align    2
        .globl    getVelocity
getVelocity:      
        lw        $v0, VELOCITY

        j         $ra
        .align    2
        .globl    getBotPxX
getBotPxX:        
        lw        $v0, BOT_X

        j         $ra
        .align    2
        .globl    getBotPxY
getBotPxY:        
        lw        $v0, BOT_Y

        j         $ra
        .align    2
        .globl    getBotX
getBotX:          
        lw        $v0, BOT_X

        srl       $v0,$v0,3
        j         $ra
        .align    2
        .globl    getBotY
getBotY:          
        lw        $v0, BOT_Y

        srl       $v0,$v0,3
        j         $ra
        .align    2
        .globl    getOpPxX
getOpPxX:         
        lw        $v0, OTHER_X

        j         $ra
        .align    2
        .globl    getOpPxY
getOpPxY:         
        lw        $v0, OTHER_Y

        j         $ra
        .align    2
        .globl    getOpX
getOpX:           
        lw        $v0, OTHER_X

        srl       $v0,$v0,3
        j         $ra
        .align    2
        .globl    getOpY
getOpY:           
        lw        $v0, OTHER_Y

        srl       $v0,$v0,3
        j         $ra
        .align    2
        .globl    getOrientation
getOrientation:   
        lw        $v0, ANGLE

        j         $ra
        .align    2
        .globl    setAbsoluteOrientation
setAbsoluteOrientation: 
        sw        $a0, ANGLE
        li        $a0, 1
        sw        $a0, ANGLE_CONTROL

        j         $ra
        .align    2
        .globl    setRelativeOrientation
setRelativeOrientation: 
        sw        $a0, ANGLE
        sw        $0, ANGLE_CONTROL

        j         $ra
        .align    2
        .globl    requestPuzzle
requestPuzzle:    
        la        $v0,puzzle_request_dest
        sw        $v0, REQUEST_PUZZLE
        j         $ra
        .align    2
        .globl    requestPuzzleAt
requestPuzzleAt:  
        sw        $a0, REQUEST_PUZZLE
        j         $ra
        .align    2
        .globl    getScores
getScores:        
        la        $v0,bot_scores
        sw        $v0, SCORES_REQUEST
        j         $ra
        .align    2
        .globl    getMyBullets
getMyBullets:     
        la        $v0,my_bullets
        sw        $v0, GET_MY_BULLETS
        j         $ra
        .align    2
        .globl    getOpBullets
getOpBullets:     
        la        $v0,op_bullets
        sw        $v0, GET_OP_BULLETS
        j         $ra
        .align    2
        .globl    getMap
getMap:           
        la        $v0,game_map
        sw        $v0, GET_MAP
        j         $ra
        .align    2
        .globl    getMapAt
getMapAt:         
        sw        $a0, GET_MAP
        j         $ra
        .align    2
        .globl    submitPuzzle
submitPuzzle:     
        sw        $a0, SUBMIT_SOLUTION
        j         $ra
        .align    2
        .globl    charge_shot
charge_shot:      
        sw        $a0, CHARGE_SHOT
        j         $ra
        .align    2
        .globl    shoot
shoot:            
        sw        $a0, SHOOT
        j         $ra
        .align    2
        .globl    getTimer
getTimer:         
        lw        $v0, TIMER
        j         $ra
        .align    2
        .globl    requestTimer
requestTimer:     
        lw        $v0, TIMER
        addu      $a0,$a0,$v0
        sw        $a0, TIMER
        j         $ra
        .align    2
        .globl    sleep
sleep:            
        lw        $v0,TIMER
        add       $a0,$v0,$a0
        bgt       $v0,$a0,$sleep405_loop_skip
$sleep405_loop:   
        lw        $v0,TIMER
        blt       $v0,$a0,$sleep405_loop
$sleep405_loop_skip: 

        j         $ra
        .align    2
        .globl    initSolver
initSolver:       
        la        $v0,puzzle_request_dest
        sw        $v0, REQUEST_PUZZLE
        j         $ra
        .align    2
        .globl    draw_line
draw_line:        
        lw        $v1,4($a2)
        subu      $v0,$a1,$a0
        sltu      $v0,$v0,$v1
        bne       $v0,$0,$L68
        move      $t1,$v1
$L65:             
        sltu      $v0,$a1,$a0
        bne       $v0,$0,$L64
        li        $t2,35                # 0x23
$L67:             
        divu      $0,$a0,$v1
        addu      $a0,$a0,$t1
        sltu      $a3,$a1,$a0
        mflo      $v0
        addiu     $v0,$v0,30
        sll       $v0,$v0,2
        addu      $v0,$a2,$v0
        lw        $v0,4($v0)
        mfhi      $t0
        addu      $v0,$v0,$t0
        sb        $t2,0($v0)
        beq       $a3,$0,$L67
$L64:             
        j         $ra
$L68:             
        li        $t1,1                  # 0x1
        b         $L65
        .align    2
        .globl    flood_fill
flood_fill:       
        lw        $v0,0($a3)
        sltu      $v0,$a0,$v0
        beq       $v0,$0,$L76
        addiu     $sp,$sp,-56
        sw        $ra,52($sp)
        sw        $s6,48($sp)
        sw        $s5,44($sp)
        sw        $s4,40($sp)
        sw        $s3,36($sp)
        sw        $s2,32($sp)
        sw        $s1,28($sp)
        sw        $s0,24($sp)
        addiu     $s5,$a0,30
        sll       $s5,$s5,2
        move      $s1,$a3
        move      $s3,$a0
        move      $s0,$a1
        move      $s2,$a2
        addu      $s5,$a3,$s5
        addiu     $s6,$a0,-1
        addiu     $s4,$a0,1
$L73:             
        lw        $v0,4($s1)
        move      $a1,$s0
        sltu      $v0,$s0,$v0
        move      $a3,$s1
        move      $a2,$s2
        move      $a0,$s6
        li        $t0,35                 # 0x23
        beq       $v0,$0,$L71
        lw        $v0,4($s5)
        addu      $v0,$v0,$s0
        lbu       $v1,0($v0)
        beq       $v1,$t0,$L71
        beq       $v1,$s2,$L71
        sb        $s2,0($v0)
        jal       flood_fill
        addiu     $a1,$s0,1
        move      $a3,$s1
        move      $a2,$s2
        move      $a0,$s3
        jal       flood_fill
        move      $a1,$s0
        move      $a3,$s1
        move      $a2,$s2
        move      $a0,$s4
        jal       flood_fill
        lw        $v0,0($s1)
        addiu     $s0,$s0,-1
        sltu      $v0,$s3,$v0
        bne       $v0,$0,$L73
$L71:             
        lw        $ra,52($sp)
        lw        $s6,48($sp)
        lw        $s5,44($sp)
        lw        $s4,40($sp)
        lw        $s3,36($sp)
        lw        $s2,32($sp)
        lw        $s1,28($sp)
        lw        $s0,24($sp)
        addiu     $sp,$sp,56
        j         $ra
$L76:             
        j         $ra
        .align    2
        .globl    count_disjoint_regions_step
count_disjoint_regions_step: 
        lw        $v0,0($a1)
        beq       $v0,$0,$L91
        lw        $t0,4($a1)
        move      $t4,$a1
        move      $t2,$a0
        addiu     $t3,$a1,124
        move      $t5,$0
        move      $t7,$0
        li        $t6,35                # 0x23
$L93:             
        move      $t1,$0
        beq       $t0,$0,$L99
$L97:             
        lw        $v1,0($t3)
        addu      $v1,$v1,$t1
        lbu       $v1,0($v1)
        beq       $v1,$t6,$L95
        move      $a1,$t1
        move      $a3,$t4
        move      $a2,$t2
        move      $a0,$t5
        beq       $v1,$t2,$L95
        addiu     $sp,$sp,-32
        sw        $ra,28($sp)
$L96:             
        jal       flood_fill
        lw        $t0,4($t4)
        addiu     $t7,$t7,1
$L82:             
        addiu     $t1,$t1,1
        sltu      $v1,$t1,$t0
        beq       $v1,$0,$L104
$L83:             
        lw        $v1,0($t3)
        addu      $v1,$v1,$t1
        lbu       $v1,0($v1)
        beq       $v1,$t6,$L82
        move      $a1,$t1
        move      $a3,$t4
        move      $a2,$t2
        move      $a0,$t5
        bne       $v1,$t2,$L96
        addiu     $t1,$t1,1
        sltu      $v1,$t1,$t0
        bne       $v1,$0,$L83
$L104:            
        lw        $v0,0($t4)
        addiu     $t5,$t5,1
        sltu      $v1,$t5,$v0
        addiu     $t3,$t3,4
        beq       $v1,$0,$L79
$L105:            
        move      $t1,$0
        bne       $t0,$0,$L83
        addiu     $t5,$t5,1
        sltu      $v1,$t5,$v0
        addiu     $t3,$t3,4
        bne       $v1,$0,$L105
$L79:             
        lw        $ra,28($sp)
        move      $v0,$t7
        addiu     $sp,$sp,32
        j         $ra
$L95:             
        addiu     $t1,$t1,1
        sltu      $v1,$t1,$t0
        bne       $v1,$0,$L97
        lw        $v0,0($t4)
$L99:             
        addiu     $t5,$t5,1
        sltu      $v1,$t5,$v0
        addiu     $t3,$t3,4
        bne       $v1,$0,$L93
        move      $v0,$t7
        j         $ra
$L91:             
        move      $t7,$v0
        move      $v0,$t7
        j         $ra
        .align    2
        .globl    count_disjoint_regions
count_disjoint_regions: 
        lw        $v0,16($a0)
        beq       $v0,$0,$L119
        addiu     $sp,$sp,-48
        sw        $ra,44($sp)
        sw        $s3,40($sp)
        sw        $s2,36($sp)
        sw        $s1,32($sp)
        sw        $s0,28($sp)
        move      $s1,$0
        move      $t9,$a0
        move      $t8,$a1
        addiu     $s2,$a0,28
        addiu     $s3,$a1,8
        li        $s0,35                # 0x23
$L111:            
        lw        $v1,0($s2)
        lw        $a0,48($s2)
        lw        $a2,4($t9)
        subu      $v0,$a0,$v1
        sltu      $v0,$v0,$a2
        bne       $v0,$0,$L112
        move      $a1,$a2
$L108:            
        sltu      $v0,$a0,$v1
        bne       $v0,$0,$L109
$L110:            
        divu      $0,$v1,$a2
        addu      $v1,$v1,$a1
        sltu      $a3,$a0,$v1
        mflo      $v0
        addiu     $v0,$v0,30
        sll       $v0,$v0,2
        addu      $v0,$t9,$v0
        lw        $v0,4($v0)
        mfhi      $t0
        addu      $v0,$v0,$t0
        sb        $s0,0($v0)
        beq       $a3,$0,$L110
$L109:            
        andi      $a0,$s1,0x1
        addiu     $a0,$a0,65
        move      $a1,$t9
        jal       count_disjoint_regions_step
        lw        $v1,16($t9)
        addiu     $s1,$s1,1
        sltu      $a0,$s1,$v1
        sw        $v1,0($t8)
        addiu     $s2,$s2,4
        sw        $v0,0($s3)
        addiu     $s3,$s3,4
        bne       $a0,$0,$L111
        lw        $ra,44($sp)
        lw        $s3,40($sp)
        lw        $s2,36($sp)
        lw        $s1,32($sp)
        lw        $s0,28($sp)
        addiu     $sp,$sp,48
        j         $ra
$L112:            
        li        $a1,1                  # 0x1
        b         $L108
$L119:            
        j         $ra
        .align    2
        .globl    solve
solve:            
        addiu     $sp,$sp,-32
        sw        $ra,28($sp)
        jal       count_disjoint_regions
        lw        $ra,28($sp)
        addiu     $sp,$sp,32
        j         $ra
        .align    2
        .globl    trySolvePuzzle
trySolvePuzzle:   
        la        $v1,interrupt_struct
        lbu       $v0,2($v1)
        andi      $v0,$v0,0x00ff
        bne       $v0,$0,$L133
        j         $ra
$L133:            
        addiu     $sp,$sp,-32
        sw        $ra,28($sp)
        la        $a1,puzzle_solution
        la        $a0,puzzle_request_dest
        sb        $0,2($v1)
        jal       count_disjoint_regions
        la        $v0,puzzle_solution
        sw        $v0, SUBMIT_SOLUTION
        la        $v0,puzzle_request_dest
        sw        $v0, REQUEST_PUZZLE
        lw        $ra,28($sp)
        li        $v0,1                  # 0x1
        addiu     $sp,$sp,32
        j         $ra
        .align    2
        .globl    main
main:             
        addiu     $sp,$sp,-64
        sw        $ra,60($sp)
        sw        $s7,56($sp)
        sw        $s6,52($sp)
        sw        $s5,48($sp)
        sw        $s4,44($sp)
        sw        $s3,40($sp)
        sw        $s2,36($sp)
        sw        $s1,32($sp)
        sw        $s0,28($sp)
        li        $t4, 0
        or        $t4, $t4, TIMER_INT_MASK # enable timer interrupt
        or        $t4, $t4, BONK_INT_MASK # enable bonk interrupt
        or        $t4, $t4, REQUEST_PUZZLE_INT_MASK # enable puzzle interrupt
        or        $t4, $t4, RESPAWN_INT_MASK # enable respawn interrupt
        or        $t4, $t4, 1           # global enable
        mtc0      $t4, $t4

        li        $v0,10                 # 0xa
        sw        $v0, VELOCITY

        la        $s0,puzzle_request_dest
        sw        $s0, REQUEST_PUZZLE
        la        $s1,puzzle_solution
        la        $s5,interrupt_struct
        la        $s7,rng_state
        la        $s3,shot_charging
        move      $s4,$s1
        move      $s2,$s0
        li        $s6,10                # 0xa
$L138:            
        lbu       $v1,2($s5)
        andi      $v1,$v1,0x00ff
        beq       $v1,$0,$L135
        move      $a1,$s4
        move      $a0,$s2
        sb        $0,2($s5)
        jal       count_disjoint_regions
        sw        $s1, SUBMIT_SOLUTION
        sw        $s0, REQUEST_PUZZLE
        li        $v1,1                  # 0x1
$L135:            
        lbu       $v0,0($s5)
        andi      $v0,$v0,0x00ff
        beq       $v0,$0,$L136
        lw        $v0,0($s7)
        sll       $a0,$v0,13
        xor       $v0,$v0,$a0
        srl       $a0,$v0,17
        xor       $v0,$v0,$a0
        sll       $a0,$v0,5
        xor       $v0,$v0,$a0
        divu      $0,$v0,$s6
        sw        $v0,0($s7)
        mfhi      $v0
        sw        $v0, VELOCITY

        sb        $0,0($s5)
$L136:            
        lbu       $v0,3($s5)
        andi      $v0,$v0,0x00ff
        beq       $v0,$0,$L137
        lw        $v0,0($s7)
        sll       $a0,$v0,13
        xor       $v0,$v0,$a0
        srl       $a0,$v0,17
        xor       $v0,$v0,$a0
        sll       $a0,$v0,5
        xor       $v0,$v0,$a0
        divu      $0,$v0,$s6
        sw        $v0,0($s7)
        mfhi      $v0
        sw        $v0, VELOCITY

        sb        $0,3($s5)
$L137:            
        beq       $v1,$0,$L138
        lw        $v0,0($s7)
        lbu       $a1,0($s3)
        sll       $a0,$v0,13
        xor       $v0,$a0,$v0
        srl       $a0,$v0,17
        xor       $a0,$a0,$v0
        sll       $v0,$a0,5
        xor       $v0,$v0,$a0
        sll       $v1,$v0,13
        xor       $v0,$v1,$v0
        srl       $v1,$v0,17
        xor       $v1,$v1,$v0
        sll       $v0,$v1,5
        andi      $a0,$a0,0x3
        xor       $v1,$v0,$v1
        beq       $a1,$0,$L139
        andi      $a1,$v1,0x3
        beq       $a0,$0,$L140
        sll       $v0,$v1,13
        xor       $v0,$v0,$v1
        srl       $v1,$v0,17
        xor       $v1,$v1,$v0
        sll       $v0,$v1,5
        xor       $v1,$v0,$v1
        move      $a0,$a1
$L139:            
        sw        $a0, CHARGE_SHOT
        li        $v0,1                  # 0x1
        sb        $v0,0($s3)
$L141:            
        li        $v0,360                # 0x168
        divu      $0,$v1,$v0
        mfhi      $v0
        sw        $v0, ANGLE
        li        $v0, 1
        sw        $v0, ANGLE_CONTROL

        sll       $v0,$v1,13
        xor       $v0,$v0,$v1
        srl       $v1,$v0,17
        xor       $v0,$v0,$v1
        sll       $v1,$v0,5
        xor       $v0,$v0,$v1
        divu      $0,$v0,$s6
        sw        $v0,0($s7)
        mfhi      $v0
        sw        $v0, VELOCITY

        b         $L138
$L140:            
        sw        $a1, SHOOT
        sll       $v0,$v1,13
        xor       $v0,$v0,$v1
        srl       $v1,$v0,17
        xor       $v1,$v1,$v0
        sll       $v0,$v1,5
        sb        $0,0($s3)
        xor       $v1,$v0,$v1
        b         $L141
        .globl    rng_state
.data             
        .align    2
rng_state:        
        .word     255
        .globl    shot_charging
shot_charging:    
        .byte     1
        .globl    game_map
        .align    2
game_map:         
        .ascii    "\001\000"
        .space    38
        .space    1560
        .globl    op_bullets
        .align    2
op_bullets:       
        .word     1
        .space    32
        .globl    my_bullets
        .align    2
my_bullets:       
        .word     1
        .space    32
        .globl    bot_scores
        .align    2
bot_scores:       
        .word     1
        .space    4
        .globl    puzzle_solution
        .align    2
puzzle_solution:  
        .space    4
        .word     puzzle_solution+8
        .space    48
        .globl    puzzle_request_dest
.data             
        .align    2
puzzle_request_dest: 
        .word     1
        .space    12
        .space    312
.kdata
chunkIH:    .space 40
ih_rng_state: .word 255
non_intrpt_str:    .asciiz "Non-interrupt exception\n"
unhandled_str:    .asciiz "Unhandled interrupt type\n"
.ktext 0x80000180
interrupt_handler:
.set noat
    move    $k1, $at        # Save $at
                            # NOTE: Don't touch $k1 or else you destroy $at!
.set at
    la      $k0, chunkIH
    sw      $a0, 0($k0)        # Get some free registers
    sw      $v0, 4($k0)        # by storing them to a global variable
    sw      $t0, 8($k0)
    sw      $t1, 12($k0)
    sw      $t2, 16($k0)
    sw      $t3, 20($k0)
    sw      $t4, 24($k0)
    sw      $t5, 28($k0)

    # Save coprocessor1 registers!
    # If you don't do this and you decide to use division or multiplication
    #   in your main code, and interrupt handler code, you get WEIRD bugs.
    mfhi    $t0
    sw      $t0, 32($k0)
    mflo    $t0
    sw      $t0, 36($k0)

    mfc0    $k0, $13                # Get Cause register
    srl     $a0, $k0, 2
    and     $a0, $a0, 0xf           # ExcCode field
    bne     $a0, 0, non_intrpt


interrupt_dispatch:                 # Interrupt:
    mfc0    $k0, $13                # Get Cause register, again
    beq     $k0, 0, done            # handled all outstanding interrupts

    and     $a0, $k0, BONK_INT_MASK     # is there a bonk interrupt?
    bne     $a0, 0, bonk_interrupt

    and     $a0, $k0, TIMER_INT_MASK    # is there a timer interrupt?
    bne     $a0, 0, timer_interrupt

    and     $a0, $k0, REQUEST_PUZZLE_INT_MASK
    bne     $a0, 0, request_puzzle_interrupt

    and     $a0, $k0, RESPAWN_INT_MASK
    bne     $a0, 0, respawn_interrupt

    li      $v0, PRINT_STRING       # Unhandled interrupt types
    la      $a0, unhandled_str
    syscall
    j       done

bonk_interrupt:
    sw      $0, BONK_ACK
    li      $a0,1
    sb      $a0,interrupt_struct
      # [NOTE: This is an inline call to rng()]
    lw    $v0,ih_rng_state
    sll   $a0,$v0,13
    xor   $a0,$a0,$v0
    srl   $v0,$a0,17
    xor   $a0,$v0,$a0
    sll   $v0,$a0,5
    xor   $v0,$v0,$a0
    sw    $v0,ih_rng_state
    li    $a0, 360
    div   $v0, $a0
    mfhi  $v0
    bgez  $v0, $positive_angle
    addu  $v0, $v0, 360
$positive_angle:
    sw    $v0, ANGLE
    sw    $0,  ANGLE_CONTROL
    li    $a0, 10
    sw    $a0, VELOCITY
    sb    $a0, interrupt_struct
    j       interrupt_dispatch      # see if other interrupts are waiting

timer_interrupt:
    sw      $0, TIMER_ACK
    li      $a0,1
    sb      $a0,interrupt_struct+1
    #Fill in your timer handler code here
    j        interrupt_dispatch     # see if other interrupts are waiting

request_puzzle_interrupt:
    sw      $0, REQUEST_PUZZLE_ACK
    li      $a0,1
    sb      $a0,interrupt_struct+2
    #Fill in your puzzle interrupt code here
    j       interrupt_dispatch

respawn_interrupt:
    sw      $0, RESPAWN_ACK
    li      $a0,1
    sb      $a0,interrupt_struct+3
    #Fill in your respawn handler code here
    j       interrupt_dispatch

non_intrpt:                         # was some non-interrupt
    li      $v0, PRINT_STRING
    la      $a0, non_intrpt_str
    syscall                         # print out an error message
    # fall through to done

done:
    la      $k0, chunkIH

    # Restore coprocessor1 registers!
    # If you don't do this and you decide to use division or multiplication
    #   in your main code, and interrupt handler code, you get WEIRD bugs.
    lw      $t0, 32($k0)
    mthi    $t0
    lw      $t0, 36($k0)
    mtlo    $t0

    lw      $a0, 0($k0)             # Restore saved registers
    lw      $v0, 4($k0)
    lw      $t0, 8($k0)
    lw      $t1, 12($k0)
    lw      $t2, 16($k0)
    lw      $t3, 20($k0)
    lw      $t4, 24($k0)
    lw      $t5, 28($k0)

.set noat
    move    $at, $k1        # Restore $at
.set at
    eret
