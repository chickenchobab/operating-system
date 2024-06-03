
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 e4 14 80       	mov    $0x8014e4d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 50 33 10 80       	mov    $0x80103350,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 b5 10 80       	mov    $0x8010b554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 c0 76 10 80       	push   $0x801076c0
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 65 46 00 00       	call   801046c0 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c fc 10 80       	mov    $0x8010fc1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc6c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc70
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 c7 76 10 80       	push   $0x801076c7
80100097:	50                   	push   %eax
80100098:	e8 f3 44 00 00       	call   80104590 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 f9 10 80    	cmp    $0x8010f9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 b5 10 80       	push   $0x8010b520
801000e4:	e8 a7 47 00 00       	call   80104890 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 fc 10 80    	mov    0x8010fc70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c fc 10 80    	mov    0x8010fc6c,%ebx
80100126:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 b5 10 80       	push   $0x8010b520
80100162:	e8 c9 46 00 00       	call   80104830 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 5e 44 00 00       	call   801045d0 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 4f 21 00 00       	call   801022e0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 ce 76 10 80       	push   $0x801076ce
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 ad 44 00 00       	call   80104670 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 07 21 00 00       	jmp    801022e0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 df 76 10 80       	push   $0x801076df
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 6c 44 00 00       	call   80104670 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 1c 44 00 00       	call   80104630 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 70 46 00 00       	call   80104890 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 b5 10 80 	movl   $0x8010b520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 bf 45 00 00       	jmp    80104830 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 e6 76 10 80       	push   $0x801076e6
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 c7 15 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801002a0:	e8 eb 45 00 00       	call   80104890 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002b5:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
        return -1;
      }
      // release(&cons.lock);
      // cprintf("%d(%s) slp\n", myproc()->pid, myproc()->name);
      // acquire(&cons.lock);
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ff 10 80       	push   $0x8010ff20
801002c8:	68 00 ff 10 80       	push   $0x8010ff00
801002cd:	e8 5e 40 00 00       	call   80104330 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 79 39 00 00       	call   80103c60 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 35 45 00 00       	call   80104830 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 7c 14 00 00       	call   80101780 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret    
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ff 10 80    	mov    %edx,0x8010ff00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 fe 10 80 	movsbl -0x7fef0180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ff 10 80       	push   $0x8010ff20
8010034c:	e8 df 44 00 00       	call   80104830 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 26 14 00 00       	call   80101780 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret    
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli    
  cons.locking = 0;
80100389:	c7 05 54 ff 10 80 00 	movl   $0x0,0x8010ff54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 42 28 00 00       	call   80102be0 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 ed 76 10 80       	push   $0x801076ed
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 8f 80 10 80 	movl   $0x8010808f,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 13 43 00 00       	call   801046e0 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 01 77 10 80       	push   $0x80107701
801003dd:	e8 be 02 00 00       	call   801006a0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ff 10 80 01 	movl   $0x1,0x8010ff58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 ea 00 00 00    	je     80100500 <consputc.part.0+0x100>
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 a1 5b 00 00       	call   80105fc0 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100441:	c1 e1 08             	shl    $0x8,%ecx
80100444:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100445:	89 f2                	mov    %esi,%edx
80100447:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100448:	0f b6 c0             	movzbl %al,%eax
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	0f 84 92 00 00 00    	je     801004e8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100456:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045c:	74 72                	je     801004d0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010045e:	0f b6 db             	movzbl %bl,%ebx
80100461:	8d 70 01             	lea    0x1(%eax),%esi
80100464:	80 cf 07             	or     $0x7,%bh
80100467:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
8010046e:	80 
  if(pos < 0 || pos > 25*80)
8010046f:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100475:	0f 8f fb 00 00 00    	jg     80100576 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010047b:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100481:	0f 8f a9 00 00 00    	jg     80100530 <consputc.part.0+0x130>
  outb(CRTPORT+1, pos>>8);
80100487:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
80100489:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100490:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100493:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100496:	bb d4 03 00 00       	mov    $0x3d4,%ebx
8010049b:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a0:	89 da                	mov    %ebx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004a8:	89 f8                	mov    %edi,%eax
801004aa:	89 ca                	mov    %ecx,%edx
801004ac:	ee                   	out    %al,(%dx)
801004ad:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004b9:	89 ca                	mov    %ecx,%edx
801004bb:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004bc:	b8 20 07 00 00       	mov    $0x720,%eax
801004c1:	66 89 06             	mov    %ax,(%esi)
}
801004c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c7:	5b                   	pop    %ebx
801004c8:	5e                   	pop    %esi
801004c9:	5f                   	pop    %edi
801004ca:	5d                   	pop    %ebp
801004cb:	c3                   	ret    
801004cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pos > 0) --pos;
801004d0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004d3:	85 c0                	test   %eax,%eax
801004d5:	75 98                	jne    8010046f <consputc.part.0+0x6f>
801004d7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004db:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004e0:	31 ff                	xor    %edi,%edi
801004e2:	eb b2                	jmp    80100496 <consputc.part.0+0x96>
801004e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004e8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004ed:	f7 e2                	mul    %edx
801004ef:	c1 ea 06             	shr    $0x6,%edx
801004f2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004f5:	c1 e0 04             	shl    $0x4,%eax
801004f8:	8d 70 50             	lea    0x50(%eax),%esi
801004fb:	e9 6f ff ff ff       	jmp    8010046f <consputc.part.0+0x6f>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100500:	83 ec 0c             	sub    $0xc,%esp
80100503:	6a 08                	push   $0x8
80100505:	e8 b6 5a 00 00       	call   80105fc0 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 aa 5a 00 00       	call   80105fc0 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 9e 5a 00 00       	call   80105fc0 <uartputc>
80100522:	83 c4 10             	add    $0x10,%esp
80100525:	e9 f8 fe ff ff       	jmp    80100422 <consputc.part.0+0x22>
8010052a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100530:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100533:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100536:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010053d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100542:	68 60 0e 00 00       	push   $0xe60
80100547:	68 a0 80 0b 80       	push   $0x800b80a0
8010054c:	68 00 80 0b 80       	push   $0x800b8000
80100551:	e8 9a 44 00 00       	call   801049f0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 e5 43 00 00       	call   80104950 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 05 77 10 80       	push   $0x80107705
8010057e:	e8 fd fd ff ff       	call   80100380 <panic>
80100583:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010058a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100590 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100590:	55                   	push   %ebp
80100591:	89 e5                	mov    %esp,%ebp
80100593:	57                   	push   %edi
80100594:	56                   	push   %esi
80100595:	53                   	push   %ebx
80100596:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100599:	ff 75 08             	push   0x8(%ebp)
{
8010059c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010059f:	e8 bc 12 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801005ab:	e8 e0 42 00 00       	call   80104890 <acquire>
  for(i = 0; i < n; i++)
801005b0:	83 c4 10             	add    $0x10,%esp
801005b3:	85 f6                	test   %esi,%esi
801005b5:	7e 25                	jle    801005dc <consolewrite+0x4c>
801005b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005ba:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005bd:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
    consputc(buf[i] & 0xff);
801005c3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005c6:	85 d2                	test   %edx,%edx
801005c8:	74 06                	je     801005d0 <consolewrite+0x40>
  asm volatile("cli");
801005ca:	fa                   	cli    
    for(;;)
801005cb:	eb fe                	jmp    801005cb <consolewrite+0x3b>
801005cd:	8d 76 00             	lea    0x0(%esi),%esi
801005d0:	e8 2b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005d5:	83 c3 01             	add    $0x1,%ebx
801005d8:	39 df                	cmp    %ebx,%edi
801005da:	75 e1                	jne    801005bd <consolewrite+0x2d>
  release(&cons.lock);
801005dc:	83 ec 0c             	sub    $0xc,%esp
801005df:	68 20 ff 10 80       	push   $0x8010ff20
801005e4:	e8 47 42 00 00       	call   80104830 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 8e 11 00 00       	call   80101780 <ilock>

  return n;
}
801005f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005f5:	89 f0                	mov    %esi,%eax
801005f7:	5b                   	pop    %ebx
801005f8:	5e                   	pop    %esi
801005f9:	5f                   	pop    %edi
801005fa:	5d                   	pop    %ebp
801005fb:	c3                   	ret    
801005fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100600 <printint>:
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 2c             	sub    $0x2c,%esp
80100609:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010060c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
8010060f:	85 c9                	test   %ecx,%ecx
80100611:	74 04                	je     80100617 <printint+0x17>
80100613:	85 c0                	test   %eax,%eax
80100615:	78 6d                	js     80100684 <printint+0x84>
    x = xx;
80100617:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010061e:	89 c1                	mov    %eax,%ecx
  i = 0;
80100620:	31 db                	xor    %ebx,%ebx
80100622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100628:	89 c8                	mov    %ecx,%eax
8010062a:	31 d2                	xor    %edx,%edx
8010062c:	89 de                	mov    %ebx,%esi
8010062e:	89 cf                	mov    %ecx,%edi
80100630:	f7 75 d4             	divl   -0x2c(%ebp)
80100633:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100636:	0f b6 92 30 77 10 80 	movzbl -0x7fef88d0(%edx),%edx
  }while((x /= base) != 0);
8010063d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010063f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100643:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100646:	73 e0                	jae    80100628 <printint+0x28>
  if(sign)
80100648:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010064b:	85 c9                	test   %ecx,%ecx
8010064d:	74 0c                	je     8010065b <printint+0x5b>
    buf[i++] = '-';
8010064f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100654:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100656:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010065b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
8010065f:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100662:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100668:	85 d2                	test   %edx,%edx
8010066a:	74 04                	je     80100670 <printint+0x70>
8010066c:	fa                   	cli    
    for(;;)
8010066d:	eb fe                	jmp    8010066d <printint+0x6d>
8010066f:	90                   	nop
80100670:	e8 8b fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
80100675:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100678:	39 c3                	cmp    %eax,%ebx
8010067a:	74 0e                	je     8010068a <printint+0x8a>
    consputc(buf[i]);
8010067c:	0f be 03             	movsbl (%ebx),%eax
8010067f:	83 eb 01             	sub    $0x1,%ebx
80100682:	eb de                	jmp    80100662 <printint+0x62>
    x = -xx;
80100684:	f7 d8                	neg    %eax
80100686:	89 c1                	mov    %eax,%ecx
80100688:	eb 96                	jmp    80100620 <printint+0x20>
}
8010068a:	83 c4 2c             	add    $0x2c,%esp
8010068d:	5b                   	pop    %ebx
8010068e:	5e                   	pop    %esi
8010068f:	5f                   	pop    %edi
80100690:	5d                   	pop    %ebp
80100691:	c3                   	ret    
80100692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801006a0 <cprintf>:
{
801006a0:	55                   	push   %ebp
801006a1:	89 e5                	mov    %esp,%ebp
801006a3:	57                   	push   %edi
801006a4:	56                   	push   %esi
801006a5:	53                   	push   %ebx
801006a6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006a9:	a1 54 ff 10 80       	mov    0x8010ff54,%eax
801006ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
801006b1:	85 c0                	test   %eax,%eax
801006b3:	0f 85 27 01 00 00    	jne    801007e0 <cprintf+0x140>
  if (fmt == 0)
801006b9:	8b 75 08             	mov    0x8(%ebp),%esi
801006bc:	85 f6                	test   %esi,%esi
801006be:	0f 84 ac 01 00 00    	je     80100870 <cprintf+0x1d0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c4:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
801006c7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006ca:	31 db                	xor    %ebx,%ebx
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 56                	je     80100726 <cprintf+0x86>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	0f 85 cf 00 00 00    	jne    801007a8 <cprintf+0x108>
    c = fmt[++i] & 0xff;
801006d9:	83 c3 01             	add    $0x1,%ebx
801006dc:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
801006e0:	85 d2                	test   %edx,%edx
801006e2:	74 42                	je     80100726 <cprintf+0x86>
    switch(c){
801006e4:	83 fa 70             	cmp    $0x70,%edx
801006e7:	0f 84 90 00 00 00    	je     8010077d <cprintf+0xdd>
801006ed:	7f 51                	jg     80100740 <cprintf+0xa0>
801006ef:	83 fa 25             	cmp    $0x25,%edx
801006f2:	0f 84 c0 00 00 00    	je     801007b8 <cprintf+0x118>
801006f8:	83 fa 64             	cmp    $0x64,%edx
801006fb:	0f 85 f4 00 00 00    	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 10, 1);
80100701:	8d 47 04             	lea    0x4(%edi),%eax
80100704:	b9 01 00 00 00       	mov    $0x1,%ecx
80100709:	ba 0a 00 00 00       	mov    $0xa,%edx
8010070e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100711:	8b 07                	mov    (%edi),%eax
80100713:	e8 e8 fe ff ff       	call   80100600 <printint>
80100718:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010071b:	83 c3 01             	add    $0x1,%ebx
8010071e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100722:	85 c0                	test   %eax,%eax
80100724:	75 aa                	jne    801006d0 <cprintf+0x30>
  if(locking)
80100726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	0f 85 22 01 00 00    	jne    80100853 <cprintf+0x1b3>
}
80100731:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100734:	5b                   	pop    %ebx
80100735:	5e                   	pop    %esi
80100736:	5f                   	pop    %edi
80100737:	5d                   	pop    %ebp
80100738:	c3                   	ret    
80100739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100740:	83 fa 73             	cmp    $0x73,%edx
80100743:	75 33                	jne    80100778 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100745:	8d 47 04             	lea    0x4(%edi),%eax
80100748:	8b 3f                	mov    (%edi),%edi
8010074a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010074d:	85 ff                	test   %edi,%edi
8010074f:	0f 84 e3 00 00 00    	je     80100838 <cprintf+0x198>
      for(; *s; s++)
80100755:	0f be 07             	movsbl (%edi),%eax
80100758:	84 c0                	test   %al,%al
8010075a:	0f 84 08 01 00 00    	je     80100868 <cprintf+0x1c8>
  if(panicked){
80100760:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100766:	85 d2                	test   %edx,%edx
80100768:	0f 84 b2 00 00 00    	je     80100820 <cprintf+0x180>
8010076e:	fa                   	cli    
    for(;;)
8010076f:	eb fe                	jmp    8010076f <cprintf+0xcf>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100778:	83 fa 78             	cmp    $0x78,%edx
8010077b:	75 78                	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 16, 0);
8010077d:	8d 47 04             	lea    0x4(%edi),%eax
80100780:	31 c9                	xor    %ecx,%ecx
80100782:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100787:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
8010078a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010078d:	8b 07                	mov    (%edi),%eax
8010078f:	e8 6c fe ff ff       	call   80100600 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100794:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
80100798:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010079b:	85 c0                	test   %eax,%eax
8010079d:	0f 85 2d ff ff ff    	jne    801006d0 <cprintf+0x30>
801007a3:	eb 81                	jmp    80100726 <cprintf+0x86>
801007a5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007a8:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007ae:	85 c9                	test   %ecx,%ecx
801007b0:	74 14                	je     801007c6 <cprintf+0x126>
801007b2:	fa                   	cli    
    for(;;)
801007b3:	eb fe                	jmp    801007b3 <cprintf+0x113>
801007b5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007b8:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
801007bd:	85 c0                	test   %eax,%eax
801007bf:	75 6c                	jne    8010082d <cprintf+0x18d>
801007c1:	b8 25 00 00 00       	mov    $0x25,%eax
801007c6:	e8 35 fc ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007cb:	83 c3 01             	add    $0x1,%ebx
801007ce:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801007d2:	85 c0                	test   %eax,%eax
801007d4:	0f 85 f6 fe ff ff    	jne    801006d0 <cprintf+0x30>
801007da:	e9 47 ff ff ff       	jmp    80100726 <cprintf+0x86>
801007df:	90                   	nop
    acquire(&cons.lock);
801007e0:	83 ec 0c             	sub    $0xc,%esp
801007e3:	68 20 ff 10 80       	push   $0x8010ff20
801007e8:	e8 a3 40 00 00       	call   80104890 <acquire>
801007ed:	83 c4 10             	add    $0x10,%esp
801007f0:	e9 c4 fe ff ff       	jmp    801006b9 <cprintf+0x19>
  if(panicked){
801007f5:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007fb:	85 c9                	test   %ecx,%ecx
801007fd:	75 31                	jne    80100830 <cprintf+0x190>
801007ff:	b8 25 00 00 00       	mov    $0x25,%eax
80100804:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100807:	e8 f4 fb ff ff       	call   80100400 <consputc.part.0>
8010080c:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100812:	85 d2                	test   %edx,%edx
80100814:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100817:	74 2e                	je     80100847 <cprintf+0x1a7>
80100819:	fa                   	cli    
    for(;;)
8010081a:	eb fe                	jmp    8010081a <cprintf+0x17a>
8010081c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100820:	e8 db fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
80100825:	83 c7 01             	add    $0x1,%edi
80100828:	e9 28 ff ff ff       	jmp    80100755 <cprintf+0xb5>
8010082d:	fa                   	cli    
    for(;;)
8010082e:	eb fe                	jmp    8010082e <cprintf+0x18e>
80100830:	fa                   	cli    
80100831:	eb fe                	jmp    80100831 <cprintf+0x191>
80100833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100837:	90                   	nop
        s = "(null)";
80100838:	bf 18 77 10 80       	mov    $0x80107718,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 ff 10 80       	push   $0x8010ff20
8010085b:	e8 d0 3f 00 00       	call   80104830 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 1f 77 10 80       	push   $0x8010771f
80100878:	e8 03 fb ff ff       	call   80100380 <panic>
8010087d:	8d 76 00             	lea    0x0(%esi),%esi

80100880 <consoleintr>:
{
80100880:	55                   	push   %ebp
80100881:	89 e5                	mov    %esp,%ebp
80100883:	57                   	push   %edi
80100884:	56                   	push   %esi
  int c, doprocdump = 0;
80100885:	31 f6                	xor    %esi,%esi
{
80100887:	53                   	push   %ebx
80100888:	83 ec 18             	sub    $0x18,%esp
8010088b:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010088e:	68 20 ff 10 80       	push   $0x8010ff20
80100893:	e8 f8 3f 00 00       	call   80104890 <acquire>
  while((c = getc()) >= 0){
80100898:	83 c4 10             	add    $0x10,%esp
8010089b:	eb 1a                	jmp    801008b7 <consoleintr+0x37>
8010089d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
801008a0:	83 fb 08             	cmp    $0x8,%ebx
801008a3:	0f 84 d7 00 00 00    	je     80100980 <consoleintr+0x100>
801008a9:	83 fb 10             	cmp    $0x10,%ebx
801008ac:	0f 85 32 01 00 00    	jne    801009e4 <consoleintr+0x164>
801008b2:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
801008b7:	ff d7                	call   *%edi
801008b9:	89 c3                	mov    %eax,%ebx
801008bb:	85 c0                	test   %eax,%eax
801008bd:	0f 88 05 01 00 00    	js     801009c8 <consoleintr+0x148>
    switch(c){
801008c3:	83 fb 15             	cmp    $0x15,%ebx
801008c6:	74 78                	je     80100940 <consoleintr+0xc0>
801008c8:	7e d6                	jle    801008a0 <consoleintr+0x20>
801008ca:	83 fb 7f             	cmp    $0x7f,%ebx
801008cd:	0f 84 ad 00 00 00    	je     80100980 <consoleintr+0x100>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008d3:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801008d8:	89 c2                	mov    %eax,%edx
801008da:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
801008e0:	83 fa 7f             	cmp    $0x7f,%edx
801008e3:	77 d2                	ja     801008b7 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e5:	8d 48 01             	lea    0x1(%eax),%ecx
  if(panicked){
801008e8:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
801008ee:	83 e0 7f             	and    $0x7f,%eax
801008f1:	89 0d 08 ff 10 80    	mov    %ecx,0x8010ff08
        c = (c == '\r') ? '\n' : c;
801008f7:	83 fb 0d             	cmp    $0xd,%ebx
801008fa:	0f 84 13 01 00 00    	je     80100a13 <consoleintr+0x193>
        input.buf[input.e++ % INPUT_BUF] = c;
80100900:	88 98 80 fe 10 80    	mov    %bl,-0x7fef0180(%eax)
  if(panicked){
80100906:	85 d2                	test   %edx,%edx
80100908:	0f 85 10 01 00 00    	jne    80100a1e <consoleintr+0x19e>
8010090e:	89 d8                	mov    %ebx,%eax
80100910:	e8 eb fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100915:	83 fb 0a             	cmp    $0xa,%ebx
80100918:	0f 84 14 01 00 00    	je     80100a32 <consoleintr+0x1b2>
8010091e:	83 fb 04             	cmp    $0x4,%ebx
80100921:	0f 84 0b 01 00 00    	je     80100a32 <consoleintr+0x1b2>
80100927:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
8010092c:	83 e8 80             	sub    $0xffffff80,%eax
8010092f:	39 05 08 ff 10 80    	cmp    %eax,0x8010ff08
80100935:	75 80                	jne    801008b7 <consoleintr+0x37>
80100937:	e9 fb 00 00 00       	jmp    80100a37 <consoleintr+0x1b7>
8010093c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
80100940:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100945:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
8010094b:	0f 84 66 ff ff ff    	je     801008b7 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100951:	83 e8 01             	sub    $0x1,%eax
80100954:	89 c2                	mov    %eax,%edx
80100956:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100959:	80 ba 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%edx)
80100960:	0f 84 51 ff ff ff    	je     801008b7 <consoleintr+0x37>
  if(panicked){
80100966:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.e--;
8010096c:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100971:	85 d2                	test   %edx,%edx
80100973:	74 33                	je     801009a8 <consoleintr+0x128>
80100975:	fa                   	cli    
    for(;;)
80100976:	eb fe                	jmp    80100976 <consoleintr+0xf6>
80100978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010097f:	90                   	nop
      if(input.e != input.w){
80100980:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100985:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
8010098b:	0f 84 26 ff ff ff    	je     801008b7 <consoleintr+0x37>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100999:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 56                	je     801009f8 <consoleintr+0x178>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x123>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
801009a8:	b8 00 01 00 00       	mov    $0x100,%eax
801009ad:	e8 4e fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
801009b2:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801009b7:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801009bd:	75 92                	jne    80100951 <consoleintr+0xd1>
801009bf:	e9 f3 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
801009c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
801009c8:	83 ec 0c             	sub    $0xc,%esp
801009cb:	68 20 ff 10 80       	push   $0x8010ff20
801009d0:	e8 5b 3e 00 00       	call   80104830 <release>
  if(doprocdump) {
801009d5:	83 c4 10             	add    $0x10,%esp
801009d8:	85 f6                	test   %esi,%esi
801009da:	75 2b                	jne    80100a07 <consoleintr+0x187>
}
801009dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009df:	5b                   	pop    %ebx
801009e0:	5e                   	pop    %esi
801009e1:	5f                   	pop    %edi
801009e2:	5d                   	pop    %ebp
801009e3:	c3                   	ret    
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009e4:	85 db                	test   %ebx,%ebx
801009e6:	0f 84 cb fe ff ff    	je     801008b7 <consoleintr+0x37>
801009ec:	e9 e2 fe ff ff       	jmp    801008d3 <consoleintr+0x53>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009f8:	b8 00 01 00 00       	mov    $0x100,%eax
801009fd:	e8 fe f9 ff ff       	call   80100400 <consputc.part.0>
80100a02:	e9 b0 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
}
80100a07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a0a:	5b                   	pop    %ebx
80100a0b:	5e                   	pop    %esi
80100a0c:	5f                   	pop    %edi
80100a0d:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a0e:	e9 bd 3a 00 00       	jmp    801044d0 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a13:	c6 80 80 fe 10 80 0a 	movb   $0xa,-0x7fef0180(%eax)
  if(panicked){
80100a1a:	85 d2                	test   %edx,%edx
80100a1c:	74 0a                	je     80100a28 <consoleintr+0x1a8>
80100a1e:	fa                   	cli    
    for(;;)
80100a1f:	eb fe                	jmp    80100a1f <consoleintr+0x19f>
80100a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a28:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a2d:	e8 ce f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a32:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
          wakeup(&input.r);
80100a37:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a3a:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
          wakeup(&input.r);
80100a3f:	68 00 ff 10 80       	push   $0x8010ff00
80100a44:	e8 a7 39 00 00       	call   801043f0 <wakeup>
80100a49:	83 c4 10             	add    $0x10,%esp
80100a4c:	e9 66 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
80100a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a5f:	90                   	nop

80100a60 <consoleinit>:

void
consoleinit(void)
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a66:	68 28 77 10 80       	push   $0x80107728
80100a6b:	68 20 ff 10 80       	push   $0x8010ff20
80100a70:	e8 4b 3c 00 00       	call   801046c0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 0c 09 11 80 90 	movl   $0x80100590,0x8011090c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 08 09 11 80 80 	movl   $0x80100280,0x80110908
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 54 ff 10 80 01 	movl   $0x1,0x8010ff54
80100a96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a99:	e8 e2 19 00 00       	call   80102480 <ioapicenable>
}
80100a9e:	83 c4 10             	add    $0x10,%esp
80100aa1:	c9                   	leave  
80100aa2:	c3                   	ret    
80100aa3:	66 90                	xchg   %ax,%ax
80100aa5:	66 90                	xchg   %ax,%ax
80100aa7:	66 90                	xchg   %ax,%ax
80100aa9:	66 90                	xchg   %ax,%ax
80100aab:	66 90                	xchg   %ax,%ax
80100aad:	66 90                	xchg   %ax,%ax
80100aaf:	90                   	nop

80100ab0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	57                   	push   %edi
80100ab4:	56                   	push   %esi
80100ab5:	53                   	push   %ebx
80100ab6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100abc:	e8 9f 31 00 00       	call   80103c60 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 84 25 00 00       	call   80103050 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 c9 15 00 00       	call   801020a0 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 02 03 00 00    	je     80100de4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c3                	mov    %eax,%ebx
80100ae7:	50                   	push   %eax
80100ae8:	e8 93 0c 00 00       	call   80101780 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	53                   	push   %ebx
80100af9:	e8 92 0f 00 00       	call   80101a90 <readi>
80100afe:	83 c4 20             	add    $0x20,%esp
80100b01:	83 f8 34             	cmp    $0x34,%eax
80100b04:	74 22                	je     80100b28 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100b06:	83 ec 0c             	sub    $0xc,%esp
80100b09:	53                   	push   %ebx
80100b0a:	e8 01 0f 00 00       	call   80101a10 <iunlockput>
    end_op();
80100b0f:	e8 ac 25 00 00       	call   801030c0 <end_op>
80100b14:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b1f:	5b                   	pop    %ebx
80100b20:	5e                   	pop    %esi
80100b21:	5f                   	pop    %edi
80100b22:	5d                   	pop    %ebp
80100b23:	c3                   	ret    
80100b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100b28:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b2f:	45 4c 46 
80100b32:	75 d2                	jne    80100b06 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100b34:	e8 37 66 00 00       	call   80107170 <setupkvm>
80100b39:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b3f:	85 c0                	test   %eax,%eax
80100b41:	74 c3                	je     80100b06 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b43:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b4a:	00 
80100b4b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b51:	0f 84 ac 02 00 00    	je     80100e03 <exec+0x353>
  sz = 0;
80100b57:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b5e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b61:	31 ff                	xor    %edi,%edi
80100b63:	e9 8e 00 00 00       	jmp    80100bf6 <exec+0x146>
80100b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b6f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100b70:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b77:	75 6c                	jne    80100be5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b79:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b7f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b85:	0f 82 87 00 00 00    	jb     80100c12 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b8b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b91:	72 7f                	jb     80100c12 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b93:	83 ec 04             	sub    $0x4,%esp
80100b96:	50                   	push   %eax
80100b97:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b9d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100ba3:	e8 e8 63 00 00       	call   80106f90 <allocuvm>
80100ba8:	83 c4 10             	add    $0x10,%esp
80100bab:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	74 5d                	je     80100c12 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100bb5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bbb:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100bc0:	75 50                	jne    80100c12 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100bc2:	83 ec 0c             	sub    $0xc,%esp
80100bc5:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100bcb:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100bd1:	53                   	push   %ebx
80100bd2:	50                   	push   %eax
80100bd3:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bd9:	e8 c2 62 00 00       	call   80106ea0 <loaduvm>
80100bde:	83 c4 20             	add    $0x20,%esp
80100be1:	85 c0                	test   %eax,%eax
80100be3:	78 2d                	js     80100c12 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100be5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bec:	83 c7 01             	add    $0x1,%edi
80100bef:	83 c6 20             	add    $0x20,%esi
80100bf2:	39 f8                	cmp    %edi,%eax
80100bf4:	7e 3a                	jle    80100c30 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bf6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bfc:	6a 20                	push   $0x20
80100bfe:	56                   	push   %esi
80100bff:	50                   	push   %eax
80100c00:	53                   	push   %ebx
80100c01:	e8 8a 0e 00 00       	call   80101a90 <readi>
80100c06:	83 c4 10             	add    $0x10,%esp
80100c09:	83 f8 20             	cmp    $0x20,%eax
80100c0c:	0f 84 5e ff ff ff    	je     80100b70 <exec+0xc0>
    freevm(pgdir);
80100c12:	83 ec 0c             	sub    $0xc,%esp
80100c15:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c1b:	e8 d0 64 00 00       	call   801070f0 <freevm>
  if(ip){
80100c20:	83 c4 10             	add    $0x10,%esp
80100c23:	e9 de fe ff ff       	jmp    80100b06 <exec+0x56>
80100c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c2f:	90                   	nop
  sz = PGROUNDUP(sz);
80100c30:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c36:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c3c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c42:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c48:	83 ec 0c             	sub    $0xc,%esp
80100c4b:	53                   	push   %ebx
80100c4c:	e8 bf 0d 00 00       	call   80101a10 <iunlockput>
  end_op();
80100c51:	e8 6a 24 00 00       	call   801030c0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	56                   	push   %esi
80100c5a:	57                   	push   %edi
80100c5b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c61:	57                   	push   %edi
80100c62:	e8 29 63 00 00       	call   80106f90 <allocuvm>
80100c67:	83 c4 10             	add    $0x10,%esp
80100c6a:	89 c6                	mov    %eax,%esi
80100c6c:	85 c0                	test   %eax,%eax
80100c6e:	0f 84 94 00 00 00    	je     80100d08 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c74:	83 ec 08             	sub    $0x8,%esp
80100c77:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c7d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c7f:	50                   	push   %eax
80100c80:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c81:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c83:	e8 88 65 00 00       	call   80107210 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c88:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c8b:	83 c4 10             	add    $0x10,%esp
80100c8e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c94:	8b 00                	mov    (%eax),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	0f 84 8b 00 00 00    	je     80100d29 <exec+0x279>
80100c9e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100ca4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100caa:	eb 23                	jmp    80100ccf <exec+0x21f>
80100cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100cb3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100cba:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100cbd:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100cc3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100cc6:	85 c0                	test   %eax,%eax
80100cc8:	74 59                	je     80100d23 <exec+0x273>
    if(argc >= MAXARG)
80100cca:	83 ff 20             	cmp    $0x20,%edi
80100ccd:	74 39                	je     80100d08 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ccf:	83 ec 0c             	sub    $0xc,%esp
80100cd2:	50                   	push   %eax
80100cd3:	e8 78 3e 00 00       	call   80104b50 <strlen>
80100cd8:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cda:	58                   	pop    %eax
80100cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cde:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce1:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ce4:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce7:	e8 64 3e 00 00       	call   80104b50 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 b3 66 00 00       	call   801073b0 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 da 63 00 00       	call   801070f0 <freevm>
80100d16:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d1e:	e9 f9 fd ff ff       	jmp    80100b1c <exec+0x6c>
80100d23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d29:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d30:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d32:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d39:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d3d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d3f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d42:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d48:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d4a:	50                   	push   %eax
80100d4b:	52                   	push   %edx
80100d4c:	53                   	push   %ebx
80100d4d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d53:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d5a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d5d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d63:	e8 48 66 00 00       	call   801073b0 <copyout>
80100d68:	83 c4 10             	add    $0x10,%esp
80100d6b:	85 c0                	test   %eax,%eax
80100d6d:	78 99                	js     80100d08 <exec+0x258>
  for(last=s=path; *s; s++)
80100d6f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d72:	8b 55 08             	mov    0x8(%ebp),%edx
80100d75:	0f b6 00             	movzbl (%eax),%eax
80100d78:	84 c0                	test   %al,%al
80100d7a:	74 13                	je     80100d8f <exec+0x2df>
80100d7c:	89 d1                	mov    %edx,%ecx
80100d7e:	66 90                	xchg   %ax,%ax
      last = s+1;
80100d80:	83 c1 01             	add    $0x1,%ecx
80100d83:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d85:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100d88:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d8b:	84 c0                	test   %al,%al
80100d8d:	75 f1                	jne    80100d80 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d8f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d95:	83 ec 04             	sub    $0x4,%esp
80100d98:	6a 10                	push   $0x10
80100d9a:	89 f8                	mov    %edi,%eax
80100d9c:	52                   	push   %edx
80100d9d:	83 c0 6c             	add    $0x6c,%eax
80100da0:	50                   	push   %eax
80100da1:	e8 6a 3d 00 00       	call   80104b10 <safestrcpy>
  curproc->pgdir = pgdir;
80100da6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100dac:	89 f8                	mov    %edi,%eax
80100dae:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100db1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100db3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100db6:	89 c1                	mov    %eax,%ecx
80100db8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dbe:	8b 40 18             	mov    0x18(%eax),%eax
80100dc1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dc4:	8b 41 18             	mov    0x18(%ecx),%eax
80100dc7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dca:	89 0c 24             	mov    %ecx,(%esp)
80100dcd:	e8 3e 5f 00 00       	call   80106d10 <switchuvm>
  freevm(oldpgdir);
80100dd2:	89 3c 24             	mov    %edi,(%esp)
80100dd5:	e8 16 63 00 00       	call   801070f0 <freevm>
  return 0;
80100dda:	83 c4 10             	add    $0x10,%esp
80100ddd:	31 c0                	xor    %eax,%eax
80100ddf:	e9 38 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100de4:	e8 d7 22 00 00       	call   801030c0 <end_op>
    cprintf("exec: fail\n");
80100de9:	83 ec 0c             	sub    $0xc,%esp
80100dec:	68 41 77 10 80       	push   $0x80107741
80100df1:	e8 aa f8 ff ff       	call   801006a0 <cprintf>
    return -1;
80100df6:	83 c4 10             	add    $0x10,%esp
80100df9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dfe:	e9 19 fd ff ff       	jmp    80100b1c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e03:	be 00 20 00 00       	mov    $0x2000,%esi
80100e08:	31 ff                	xor    %edi,%edi
80100e0a:	e9 39 fe ff ff       	jmp    80100c48 <exec+0x198>
80100e0f:	90                   	nop

80100e10 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e16:	68 4d 77 10 80       	push   $0x8010774d
80100e1b:	68 60 ff 10 80       	push   $0x8010ff60
80100e20:	e8 9b 38 00 00       	call   801046c0 <initlock>
}
80100e25:	83 c4 10             	add    $0x10,%esp
80100e28:	c9                   	leave  
80100e29:	c3                   	ret    
80100e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e30 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e34:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
{
80100e39:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e3c:	68 60 ff 10 80       	push   $0x8010ff60
80100e41:	e8 4a 3a 00 00       	call   80104890 <acquire>
80100e46:	83 c4 10             	add    $0x10,%esp
80100e49:	eb 10                	jmp    80100e5b <filealloc+0x2b>
80100e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e4f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e50:	83 c3 18             	add    $0x18,%ebx
80100e53:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
80100e59:	74 25                	je     80100e80 <filealloc+0x50>
    if(f->ref == 0){
80100e5b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e5e:	85 c0                	test   %eax,%eax
80100e60:	75 ee                	jne    80100e50 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e62:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e65:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e6c:	68 60 ff 10 80       	push   $0x8010ff60
80100e71:	e8 ba 39 00 00       	call   80104830 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e76:	89 d8                	mov    %ebx,%eax
      return f;
80100e78:	83 c4 10             	add    $0x10,%esp
}
80100e7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e7e:	c9                   	leave  
80100e7f:	c3                   	ret    
  release(&ftable.lock);
80100e80:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e83:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e85:	68 60 ff 10 80       	push   $0x8010ff60
80100e8a:	e8 a1 39 00 00       	call   80104830 <release>
}
80100e8f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e91:	83 c4 10             	add    $0x10,%esp
}
80100e94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e97:	c9                   	leave  
80100e98:	c3                   	ret    
80100e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ea0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ea0:	55                   	push   %ebp
80100ea1:	89 e5                	mov    %esp,%ebp
80100ea3:	53                   	push   %ebx
80100ea4:	83 ec 10             	sub    $0x10,%esp
80100ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eaa:	68 60 ff 10 80       	push   $0x8010ff60
80100eaf:	e8 dc 39 00 00       	call   80104890 <acquire>
  if(f->ref < 1)
80100eb4:	8b 43 04             	mov    0x4(%ebx),%eax
80100eb7:	83 c4 10             	add    $0x10,%esp
80100eba:	85 c0                	test   %eax,%eax
80100ebc:	7e 1a                	jle    80100ed8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ebe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ec1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ec4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ec7:	68 60 ff 10 80       	push   $0x8010ff60
80100ecc:	e8 5f 39 00 00       	call   80104830 <release>
  return f;
}
80100ed1:	89 d8                	mov    %ebx,%eax
80100ed3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ed6:	c9                   	leave  
80100ed7:	c3                   	ret    
    panic("filedup");
80100ed8:	83 ec 0c             	sub    $0xc,%esp
80100edb:	68 54 77 10 80       	push   $0x80107754
80100ee0:	e8 9b f4 ff ff       	call   80100380 <panic>
80100ee5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	57                   	push   %edi
80100ef4:	56                   	push   %esi
80100ef5:	53                   	push   %ebx
80100ef6:	83 ec 28             	sub    $0x28,%esp
80100ef9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100efc:	68 60 ff 10 80       	push   $0x8010ff60
80100f01:	e8 8a 39 00 00       	call   80104890 <acquire>
  if(f->ref < 1)
80100f06:	8b 53 04             	mov    0x4(%ebx),%edx
80100f09:	83 c4 10             	add    $0x10,%esp
80100f0c:	85 d2                	test   %edx,%edx
80100f0e:	0f 8e a5 00 00 00    	jle    80100fb9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f14:	83 ea 01             	sub    $0x1,%edx
80100f17:	89 53 04             	mov    %edx,0x4(%ebx)
80100f1a:	75 44                	jne    80100f60 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f1c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f20:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f23:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f25:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f2b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f2e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f31:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f34:	68 60 ff 10 80       	push   $0x8010ff60
  ff = *f;
80100f39:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f3c:	e8 ef 38 00 00       	call   80104830 <release>

  if(ff.type == FD_PIPE)
80100f41:	83 c4 10             	add    $0x10,%esp
80100f44:	83 ff 01             	cmp    $0x1,%edi
80100f47:	74 57                	je     80100fa0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f49:	83 ff 02             	cmp    $0x2,%edi
80100f4c:	74 2a                	je     80100f78 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f51:	5b                   	pop    %ebx
80100f52:	5e                   	pop    %esi
80100f53:	5f                   	pop    %edi
80100f54:	5d                   	pop    %ebp
80100f55:	c3                   	ret    
80100f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f5d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f60:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
}
80100f67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6a:	5b                   	pop    %ebx
80100f6b:	5e                   	pop    %esi
80100f6c:	5f                   	pop    %edi
80100f6d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f6e:	e9 bd 38 00 00       	jmp    80104830 <release>
80100f73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f77:	90                   	nop
    begin_op();
80100f78:	e8 d3 20 00 00       	call   80103050 <begin_op>
    iput(ff.ip);
80100f7d:	83 ec 0c             	sub    $0xc,%esp
80100f80:	ff 75 e0             	push   -0x20(%ebp)
80100f83:	e8 28 09 00 00       	call   801018b0 <iput>
    end_op();
80100f88:	83 c4 10             	add    $0x10,%esp
}
80100f8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8e:	5b                   	pop    %ebx
80100f8f:	5e                   	pop    %esi
80100f90:	5f                   	pop    %edi
80100f91:	5d                   	pop    %ebp
    end_op();
80100f92:	e9 29 21 00 00       	jmp    801030c0 <end_op>
80100f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100fa0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fa4:	83 ec 08             	sub    $0x8,%esp
80100fa7:	53                   	push   %ebx
80100fa8:	56                   	push   %esi
80100fa9:	e8 72 28 00 00       	call   80103820 <pipeclose>
80100fae:	83 c4 10             	add    $0x10,%esp
}
80100fb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb4:	5b                   	pop    %ebx
80100fb5:	5e                   	pop    %esi
80100fb6:	5f                   	pop    %edi
80100fb7:	5d                   	pop    %ebp
80100fb8:	c3                   	ret    
    panic("fileclose");
80100fb9:	83 ec 0c             	sub    $0xc,%esp
80100fbc:	68 5c 77 10 80       	push   $0x8010775c
80100fc1:	e8 ba f3 ff ff       	call   80100380 <panic>
80100fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fcd:	8d 76 00             	lea    0x0(%esi),%esi

80100fd0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	53                   	push   %ebx
80100fd4:	83 ec 04             	sub    $0x4,%esp
80100fd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fda:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fdd:	75 31                	jne    80101010 <filestat+0x40>
    ilock(f->ip);
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	ff 73 10             	push   0x10(%ebx)
80100fe5:	e8 96 07 00 00       	call   80101780 <ilock>
    stati(f->ip, st);
80100fea:	58                   	pop    %eax
80100feb:	5a                   	pop    %edx
80100fec:	ff 75 0c             	push   0xc(%ebp)
80100fef:	ff 73 10             	push   0x10(%ebx)
80100ff2:	e8 69 0a 00 00       	call   80101a60 <stati>
    iunlock(f->ip);
80100ff7:	59                   	pop    %ecx
80100ff8:	ff 73 10             	push   0x10(%ebx)
80100ffb:	e8 60 08 00 00       	call   80101860 <iunlock>
    return 0;
  }
  return -1;
}
80101000:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101003:	83 c4 10             	add    $0x10,%esp
80101006:	31 c0                	xor    %eax,%eax
}
80101008:	c9                   	leave  
80101009:	c3                   	ret    
8010100a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101010:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101013:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101018:	c9                   	leave  
80101019:	c3                   	ret    
8010101a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101020 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	57                   	push   %edi
80101024:	56                   	push   %esi
80101025:	53                   	push   %ebx
80101026:	83 ec 0c             	sub    $0xc,%esp
80101029:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010102c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010102f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101032:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101036:	74 60                	je     80101098 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101038:	8b 03                	mov    (%ebx),%eax
8010103a:	83 f8 01             	cmp    $0x1,%eax
8010103d:	74 41                	je     80101080 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010103f:	83 f8 02             	cmp    $0x2,%eax
80101042:	75 5b                	jne    8010109f <fileread+0x7f>
    ilock(f->ip);
80101044:	83 ec 0c             	sub    $0xc,%esp
80101047:	ff 73 10             	push   0x10(%ebx)
8010104a:	e8 31 07 00 00       	call   80101780 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010104f:	57                   	push   %edi
80101050:	ff 73 14             	push   0x14(%ebx)
80101053:	56                   	push   %esi
80101054:	ff 73 10             	push   0x10(%ebx)
80101057:	e8 34 0a 00 00       	call   80101a90 <readi>
8010105c:	83 c4 20             	add    $0x20,%esp
8010105f:	89 c6                	mov    %eax,%esi
80101061:	85 c0                	test   %eax,%eax
80101063:	7e 03                	jle    80101068 <fileread+0x48>
      f->off += r;
80101065:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101068:	83 ec 0c             	sub    $0xc,%esp
8010106b:	ff 73 10             	push   0x10(%ebx)
8010106e:	e8 ed 07 00 00       	call   80101860 <iunlock>
    return r;
80101073:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101076:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101079:	89 f0                	mov    %esi,%eax
8010107b:	5b                   	pop    %ebx
8010107c:	5e                   	pop    %esi
8010107d:	5f                   	pop    %edi
8010107e:	5d                   	pop    %ebp
8010107f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101080:	8b 43 0c             	mov    0xc(%ebx),%eax
80101083:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101086:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101089:	5b                   	pop    %ebx
8010108a:	5e                   	pop    %esi
8010108b:	5f                   	pop    %edi
8010108c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010108d:	e9 2e 29 00 00       	jmp    801039c0 <piperead>
80101092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101098:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010109d:	eb d7                	jmp    80101076 <fileread+0x56>
  panic("fileread");
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	68 66 77 10 80       	push   $0x80107766
801010a7:	e8 d4 f2 ff ff       	call   80100380 <panic>
801010ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010b0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010b0:	55                   	push   %ebp
801010b1:	89 e5                	mov    %esp,%ebp
801010b3:	57                   	push   %edi
801010b4:	56                   	push   %esi
801010b5:	53                   	push   %ebx
801010b6:	83 ec 1c             	sub    $0x1c,%esp
801010b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801010bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010c2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010c5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801010c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010cc:	0f 84 bd 00 00 00    	je     8010118f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
801010d2:	8b 03                	mov    (%ebx),%eax
801010d4:	83 f8 01             	cmp    $0x1,%eax
801010d7:	0f 84 bf 00 00 00    	je     8010119c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010dd:	83 f8 02             	cmp    $0x2,%eax
801010e0:	0f 85 c8 00 00 00    	jne    801011ae <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010e9:	31 f6                	xor    %esi,%esi
    while(i < n){
801010eb:	85 c0                	test   %eax,%eax
801010ed:	7f 30                	jg     8010111f <filewrite+0x6f>
801010ef:	e9 94 00 00 00       	jmp    80101188 <filewrite+0xd8>
801010f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010f8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
801010fb:	83 ec 0c             	sub    $0xc,%esp
801010fe:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101101:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101104:	e8 57 07 00 00       	call   80101860 <iunlock>
      end_op();
80101109:	e8 b2 1f 00 00       	call   801030c0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010110e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101111:	83 c4 10             	add    $0x10,%esp
80101114:	39 c7                	cmp    %eax,%edi
80101116:	75 5c                	jne    80101174 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101118:	01 fe                	add    %edi,%esi
    while(i < n){
8010111a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010111d:	7e 69                	jle    80101188 <filewrite+0xd8>
      int n1 = n - i;
8010111f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101122:	b8 00 06 00 00       	mov    $0x600,%eax
80101127:	29 f7                	sub    %esi,%edi
80101129:	39 c7                	cmp    %eax,%edi
8010112b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010112e:	e8 1d 1f 00 00       	call   80103050 <begin_op>
      ilock(f->ip);
80101133:	83 ec 0c             	sub    $0xc,%esp
80101136:	ff 73 10             	push   0x10(%ebx)
80101139:	e8 42 06 00 00       	call   80101780 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010113e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101141:	57                   	push   %edi
80101142:	ff 73 14             	push   0x14(%ebx)
80101145:	01 f0                	add    %esi,%eax
80101147:	50                   	push   %eax
80101148:	ff 73 10             	push   0x10(%ebx)
8010114b:	e8 40 0a 00 00       	call   80101b90 <writei>
80101150:	83 c4 20             	add    $0x20,%esp
80101153:	85 c0                	test   %eax,%eax
80101155:	7f a1                	jg     801010f8 <filewrite+0x48>
      iunlock(f->ip);
80101157:	83 ec 0c             	sub    $0xc,%esp
8010115a:	ff 73 10             	push   0x10(%ebx)
8010115d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101160:	e8 fb 06 00 00       	call   80101860 <iunlock>
      end_op();
80101165:	e8 56 1f 00 00       	call   801030c0 <end_op>
      if(r < 0)
8010116a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010116d:	83 c4 10             	add    $0x10,%esp
80101170:	85 c0                	test   %eax,%eax
80101172:	75 1b                	jne    8010118f <filewrite+0xdf>
        panic("short filewrite");
80101174:	83 ec 0c             	sub    $0xc,%esp
80101177:	68 6f 77 10 80       	push   $0x8010776f
8010117c:	e8 ff f1 ff ff       	call   80100380 <panic>
80101181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101188:	89 f0                	mov    %esi,%eax
8010118a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010118d:	74 05                	je     80101194 <filewrite+0xe4>
8010118f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101197:	5b                   	pop    %ebx
80101198:	5e                   	pop    %esi
80101199:	5f                   	pop    %edi
8010119a:	5d                   	pop    %ebp
8010119b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010119c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010119f:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a5:	5b                   	pop    %ebx
801011a6:	5e                   	pop    %esi
801011a7:	5f                   	pop    %edi
801011a8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011a9:	e9 12 27 00 00       	jmp    801038c0 <pipewrite>
  panic("filewrite");
801011ae:	83 ec 0c             	sub    $0xc,%esp
801011b1:	68 75 77 10 80       	push   $0x80107775
801011b6:	e8 c5 f1 ff ff       	call   80100380 <panic>
801011bb:	66 90                	xchg   %ax,%ax
801011bd:	66 90                	xchg   %ax,%ax
801011bf:	90                   	nop

801011c0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011c0:	55                   	push   %ebp
801011c1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011c3:	89 d0                	mov    %edx,%eax
801011c5:	c1 e8 0c             	shr    $0xc,%eax
801011c8:	03 05 cc 25 11 80    	add    0x801125cc,%eax
{
801011ce:	89 e5                	mov    %esp,%ebp
801011d0:	56                   	push   %esi
801011d1:	53                   	push   %ebx
801011d2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011d4:	83 ec 08             	sub    $0x8,%esp
801011d7:	50                   	push   %eax
801011d8:	51                   	push   %ecx
801011d9:	e8 f2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011de:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011e0:	c1 fb 03             	sar    $0x3,%ebx
801011e3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801011e6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801011e8:	83 e1 07             	and    $0x7,%ecx
801011eb:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
801011f0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
801011f6:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801011f8:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
801011fd:	85 c1                	test   %eax,%ecx
801011ff:	74 23                	je     80101224 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101201:	f7 d0                	not    %eax
  log_write(bp);
80101203:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101206:	21 c8                	and    %ecx,%eax
80101208:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010120c:	56                   	push   %esi
8010120d:	e8 1e 20 00 00       	call   80103230 <log_write>
  brelse(bp);
80101212:	89 34 24             	mov    %esi,(%esp)
80101215:	e8 d6 ef ff ff       	call   801001f0 <brelse>
}
8010121a:	83 c4 10             	add    $0x10,%esp
8010121d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101220:	5b                   	pop    %ebx
80101221:	5e                   	pop    %esi
80101222:	5d                   	pop    %ebp
80101223:	c3                   	ret    
    panic("freeing free block");
80101224:	83 ec 0c             	sub    $0xc,%esp
80101227:	68 7f 77 10 80       	push   $0x8010777f
8010122c:	e8 4f f1 ff ff       	call   80100380 <panic>
80101231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010123f:	90                   	nop

80101240 <balloc>:
{
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	57                   	push   %edi
80101244:	56                   	push   %esi
80101245:	53                   	push   %ebx
80101246:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101249:	8b 0d b4 25 11 80    	mov    0x801125b4,%ecx
{
8010124f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101252:	85 c9                	test   %ecx,%ecx
80101254:	0f 84 87 00 00 00    	je     801012e1 <balloc+0xa1>
8010125a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101261:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101264:	83 ec 08             	sub    $0x8,%esp
80101267:	89 f0                	mov    %esi,%eax
80101269:	c1 f8 0c             	sar    $0xc,%eax
8010126c:	03 05 cc 25 11 80    	add    0x801125cc,%eax
80101272:	50                   	push   %eax
80101273:	ff 75 d8             	push   -0x28(%ebp)
80101276:	e8 55 ee ff ff       	call   801000d0 <bread>
8010127b:	83 c4 10             	add    $0x10,%esp
8010127e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101281:	a1 b4 25 11 80       	mov    0x801125b4,%eax
80101286:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101289:	31 c0                	xor    %eax,%eax
8010128b:	eb 2f                	jmp    801012bc <balloc+0x7c>
8010128d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101290:	89 c1                	mov    %eax,%ecx
80101292:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101297:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010129a:	83 e1 07             	and    $0x7,%ecx
8010129d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010129f:	89 c1                	mov    %eax,%ecx
801012a1:	c1 f9 03             	sar    $0x3,%ecx
801012a4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012a9:	89 fa                	mov    %edi,%edx
801012ab:	85 df                	test   %ebx,%edi
801012ad:	74 41                	je     801012f0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012af:	83 c0 01             	add    $0x1,%eax
801012b2:	83 c6 01             	add    $0x1,%esi
801012b5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ba:	74 05                	je     801012c1 <balloc+0x81>
801012bc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012bf:	77 cf                	ja     80101290 <balloc+0x50>
    brelse(bp);
801012c1:	83 ec 0c             	sub    $0xc,%esp
801012c4:	ff 75 e4             	push   -0x1c(%ebp)
801012c7:	e8 24 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012cc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012d3:	83 c4 10             	add    $0x10,%esp
801012d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012d9:	39 05 b4 25 11 80    	cmp    %eax,0x801125b4
801012df:	77 80                	ja     80101261 <balloc+0x21>
  panic("balloc: out of blocks");
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	68 92 77 10 80       	push   $0x80107792
801012e9:	e8 92 f0 ff ff       	call   80100380 <panic>
801012ee:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012f3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012f6:	09 da                	or     %ebx,%edx
801012f8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012fc:	57                   	push   %edi
801012fd:	e8 2e 1f 00 00       	call   80103230 <log_write>
        brelse(bp);
80101302:	89 3c 24             	mov    %edi,(%esp)
80101305:	e8 e6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010130a:	58                   	pop    %eax
8010130b:	5a                   	pop    %edx
8010130c:	56                   	push   %esi
8010130d:	ff 75 d8             	push   -0x28(%ebp)
80101310:	e8 bb ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101315:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101318:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010131a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010131d:	68 00 02 00 00       	push   $0x200
80101322:	6a 00                	push   $0x0
80101324:	50                   	push   %eax
80101325:	e8 26 36 00 00       	call   80104950 <memset>
  log_write(bp);
8010132a:	89 1c 24             	mov    %ebx,(%esp)
8010132d:	e8 fe 1e 00 00       	call   80103230 <log_write>
  brelse(bp);
80101332:	89 1c 24             	mov    %ebx,(%esp)
80101335:	e8 b6 ee ff ff       	call   801001f0 <brelse>
}
8010133a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010133d:	89 f0                	mov    %esi,%eax
8010133f:	5b                   	pop    %ebx
80101340:	5e                   	pop    %esi
80101341:	5f                   	pop    %edi
80101342:	5d                   	pop    %ebp
80101343:	c3                   	ret    
80101344:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010134b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010134f:	90                   	nop

80101350 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	57                   	push   %edi
80101354:	89 c7                	mov    %eax,%edi
80101356:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101357:	31 f6                	xor    %esi,%esi
{
80101359:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135a:	bb 94 09 11 80       	mov    $0x80110994,%ebx
{
8010135f:	83 ec 28             	sub    $0x28,%esp
80101362:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101365:	68 60 09 11 80       	push   $0x80110960
8010136a:	e8 21 35 00 00       	call   80104890 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010136f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101372:	83 c4 10             	add    $0x10,%esp
80101375:	eb 1b                	jmp    80101392 <iget+0x42>
80101377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010137e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101380:	39 3b                	cmp    %edi,(%ebx)
80101382:	74 6c                	je     801013f0 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101384:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010138a:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101390:	73 26                	jae    801013b8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101392:	8b 43 08             	mov    0x8(%ebx),%eax
80101395:	85 c0                	test   %eax,%eax
80101397:	7f e7                	jg     80101380 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101399:	85 f6                	test   %esi,%esi
8010139b:	75 e7                	jne    80101384 <iget+0x34>
8010139d:	85 c0                	test   %eax,%eax
8010139f:	75 76                	jne    80101417 <iget+0xc7>
801013a1:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013a3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013a9:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801013af:	72 e1                	jb     80101392 <iget+0x42>
801013b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013b8:	85 f6                	test   %esi,%esi
801013ba:	74 79                	je     80101435 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013bc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013bf:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013c1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013c4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013cb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013d2:	68 60 09 11 80       	push   $0x80110960
801013d7:	e8 54 34 00 00       	call   80104830 <release>

  return ip;
801013dc:	83 c4 10             	add    $0x10,%esp
}
801013df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e2:	89 f0                	mov    %esi,%eax
801013e4:	5b                   	pop    %ebx
801013e5:	5e                   	pop    %esi
801013e6:	5f                   	pop    %edi
801013e7:	5d                   	pop    %ebp
801013e8:	c3                   	ret    
801013e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013f3:	75 8f                	jne    80101384 <iget+0x34>
      release(&icache.lock);
801013f5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013f8:	83 c0 01             	add    $0x1,%eax
      return ip;
801013fb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013fd:	68 60 09 11 80       	push   $0x80110960
      ip->ref++;
80101402:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101405:	e8 26 34 00 00       	call   80104830 <release>
      return ip;
8010140a:	83 c4 10             	add    $0x10,%esp
}
8010140d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101410:	89 f0                	mov    %esi,%eax
80101412:	5b                   	pop    %ebx
80101413:	5e                   	pop    %esi
80101414:	5f                   	pop    %edi
80101415:	5d                   	pop    %ebp
80101416:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101417:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010141d:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101423:	73 10                	jae    80101435 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101425:	8b 43 08             	mov    0x8(%ebx),%eax
80101428:	85 c0                	test   %eax,%eax
8010142a:	0f 8f 50 ff ff ff    	jg     80101380 <iget+0x30>
80101430:	e9 68 ff ff ff       	jmp    8010139d <iget+0x4d>
    panic("iget: no inodes");
80101435:	83 ec 0c             	sub    $0xc,%esp
80101438:	68 a8 77 10 80       	push   $0x801077a8
8010143d:	e8 3e ef ff ff       	call   80100380 <panic>
80101442:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101450 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101450:	55                   	push   %ebp
80101451:	89 e5                	mov    %esp,%ebp
80101453:	57                   	push   %edi
80101454:	56                   	push   %esi
80101455:	89 c6                	mov    %eax,%esi
80101457:	53                   	push   %ebx
80101458:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010145b:	83 fa 0b             	cmp    $0xb,%edx
8010145e:	0f 86 8c 00 00 00    	jbe    801014f0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101464:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101467:	83 fb 7f             	cmp    $0x7f,%ebx
8010146a:	0f 87 a2 00 00 00    	ja     80101512 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101470:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101476:	85 c0                	test   %eax,%eax
80101478:	74 5e                	je     801014d8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010147a:	83 ec 08             	sub    $0x8,%esp
8010147d:	50                   	push   %eax
8010147e:	ff 36                	push   (%esi)
80101480:	e8 4b ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101485:	83 c4 10             	add    $0x10,%esp
80101488:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010148c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010148e:	8b 3b                	mov    (%ebx),%edi
80101490:	85 ff                	test   %edi,%edi
80101492:	74 1c                	je     801014b0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101494:	83 ec 0c             	sub    $0xc,%esp
80101497:	52                   	push   %edx
80101498:	e8 53 ed ff ff       	call   801001f0 <brelse>
8010149d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014a3:	89 f8                	mov    %edi,%eax
801014a5:	5b                   	pop    %ebx
801014a6:	5e                   	pop    %esi
801014a7:	5f                   	pop    %edi
801014a8:	5d                   	pop    %ebp
801014a9:	c3                   	ret    
801014aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801014b3:	8b 06                	mov    (%esi),%eax
801014b5:	e8 86 fd ff ff       	call   80101240 <balloc>
      log_write(bp);
801014ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014bd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014c0:	89 03                	mov    %eax,(%ebx)
801014c2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801014c4:	52                   	push   %edx
801014c5:	e8 66 1d 00 00       	call   80103230 <log_write>
801014ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014cd:	83 c4 10             	add    $0x10,%esp
801014d0:	eb c2                	jmp    80101494 <bmap+0x44>
801014d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014d8:	8b 06                	mov    (%esi),%eax
801014da:	e8 61 fd ff ff       	call   80101240 <balloc>
801014df:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014e5:	eb 93                	jmp    8010147a <bmap+0x2a>
801014e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014ee:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
801014f0:	8d 5a 14             	lea    0x14(%edx),%ebx
801014f3:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
801014f7:	85 ff                	test   %edi,%edi
801014f9:	75 a5                	jne    801014a0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014fb:	8b 00                	mov    (%eax),%eax
801014fd:	e8 3e fd ff ff       	call   80101240 <balloc>
80101502:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101506:	89 c7                	mov    %eax,%edi
}
80101508:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010150b:	5b                   	pop    %ebx
8010150c:	89 f8                	mov    %edi,%eax
8010150e:	5e                   	pop    %esi
8010150f:	5f                   	pop    %edi
80101510:	5d                   	pop    %ebp
80101511:	c3                   	ret    
  panic("bmap: out of range");
80101512:	83 ec 0c             	sub    $0xc,%esp
80101515:	68 b8 77 10 80       	push   $0x801077b8
8010151a:	e8 61 ee ff ff       	call   80100380 <panic>
8010151f:	90                   	nop

80101520 <readsb>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	56                   	push   %esi
80101524:	53                   	push   %ebx
80101525:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101528:	83 ec 08             	sub    $0x8,%esp
8010152b:	6a 01                	push   $0x1
8010152d:	ff 75 08             	push   0x8(%ebp)
80101530:	e8 9b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101535:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101538:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010153a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010153d:	6a 1c                	push   $0x1c
8010153f:	50                   	push   %eax
80101540:	56                   	push   %esi
80101541:	e8 aa 34 00 00       	call   801049f0 <memmove>
  brelse(bp);
80101546:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101549:	83 c4 10             	add    $0x10,%esp
}
8010154c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010154f:	5b                   	pop    %ebx
80101550:	5e                   	pop    %esi
80101551:	5d                   	pop    %ebp
  brelse(bp);
80101552:	e9 99 ec ff ff       	jmp    801001f0 <brelse>
80101557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010155e:	66 90                	xchg   %ax,%ax

80101560 <iinit>:
{
80101560:	55                   	push   %ebp
80101561:	89 e5                	mov    %esp,%ebp
80101563:	53                   	push   %ebx
80101564:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
80101569:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010156c:	68 cb 77 10 80       	push   $0x801077cb
80101571:	68 60 09 11 80       	push   $0x80110960
80101576:	e8 45 31 00 00       	call   801046c0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010157b:	83 c4 10             	add    $0x10,%esp
8010157e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101580:	83 ec 08             	sub    $0x8,%esp
80101583:	68 d2 77 10 80       	push   $0x801077d2
80101588:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101589:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010158f:	e8 fc 2f 00 00       	call   80104590 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101594:	83 c4 10             	add    $0x10,%esp
80101597:	81 fb c0 25 11 80    	cmp    $0x801125c0,%ebx
8010159d:	75 e1                	jne    80101580 <iinit+0x20>
  bp = bread(dev, 1);
8010159f:	83 ec 08             	sub    $0x8,%esp
801015a2:	6a 01                	push   $0x1
801015a4:	ff 75 08             	push   0x8(%ebp)
801015a7:	e8 24 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015ac:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015af:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015b1:	8d 40 5c             	lea    0x5c(%eax),%eax
801015b4:	6a 1c                	push   $0x1c
801015b6:	50                   	push   %eax
801015b7:	68 b4 25 11 80       	push   $0x801125b4
801015bc:	e8 2f 34 00 00       	call   801049f0 <memmove>
  brelse(bp);
801015c1:	89 1c 24             	mov    %ebx,(%esp)
801015c4:	e8 27 ec ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015c9:	ff 35 cc 25 11 80    	push   0x801125cc
801015cf:	ff 35 c8 25 11 80    	push   0x801125c8
801015d5:	ff 35 c4 25 11 80    	push   0x801125c4
801015db:	ff 35 c0 25 11 80    	push   0x801125c0
801015e1:	ff 35 bc 25 11 80    	push   0x801125bc
801015e7:	ff 35 b8 25 11 80    	push   0x801125b8
801015ed:	ff 35 b4 25 11 80    	push   0x801125b4
801015f3:	68 38 78 10 80       	push   $0x80107838
801015f8:	e8 a3 f0 ff ff       	call   801006a0 <cprintf>
}
801015fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101600:	83 c4 30             	add    $0x30,%esp
80101603:	c9                   	leave  
80101604:	c3                   	ret    
80101605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010160c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101610 <ialloc>:
{
80101610:	55                   	push   %ebp
80101611:	89 e5                	mov    %esp,%ebp
80101613:	57                   	push   %edi
80101614:	56                   	push   %esi
80101615:	53                   	push   %ebx
80101616:	83 ec 1c             	sub    $0x1c,%esp
80101619:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010161c:	83 3d bc 25 11 80 01 	cmpl   $0x1,0x801125bc
{
80101623:	8b 75 08             	mov    0x8(%ebp),%esi
80101626:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101629:	0f 86 91 00 00 00    	jbe    801016c0 <ialloc+0xb0>
8010162f:	bf 01 00 00 00       	mov    $0x1,%edi
80101634:	eb 21                	jmp    80101657 <ialloc+0x47>
80101636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010163d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101640:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101643:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101646:	53                   	push   %ebx
80101647:	e8 a4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010164c:	83 c4 10             	add    $0x10,%esp
8010164f:	3b 3d bc 25 11 80    	cmp    0x801125bc,%edi
80101655:	73 69                	jae    801016c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101657:	89 f8                	mov    %edi,%eax
80101659:	83 ec 08             	sub    $0x8,%esp
8010165c:	c1 e8 03             	shr    $0x3,%eax
8010165f:	03 05 c8 25 11 80    	add    0x801125c8,%eax
80101665:	50                   	push   %eax
80101666:	56                   	push   %esi
80101667:	e8 64 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010166c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010166f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101671:	89 f8                	mov    %edi,%eax
80101673:	83 e0 07             	and    $0x7,%eax
80101676:	c1 e0 06             	shl    $0x6,%eax
80101679:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010167d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101681:	75 bd                	jne    80101640 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101683:	83 ec 04             	sub    $0x4,%esp
80101686:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101689:	6a 40                	push   $0x40
8010168b:	6a 00                	push   $0x0
8010168d:	51                   	push   %ecx
8010168e:	e8 bd 32 00 00       	call   80104950 <memset>
      dip->type = type;
80101693:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101697:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010169a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010169d:	89 1c 24             	mov    %ebx,(%esp)
801016a0:	e8 8b 1b 00 00       	call   80103230 <log_write>
      brelse(bp);
801016a5:	89 1c 24             	mov    %ebx,(%esp)
801016a8:	e8 43 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016ad:	83 c4 10             	add    $0x10,%esp
}
801016b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016b3:	89 fa                	mov    %edi,%edx
}
801016b5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016b6:	89 f0                	mov    %esi,%eax
}
801016b8:	5e                   	pop    %esi
801016b9:	5f                   	pop    %edi
801016ba:	5d                   	pop    %ebp
      return iget(dev, inum);
801016bb:	e9 90 fc ff ff       	jmp    80101350 <iget>
  panic("ialloc: no inodes");
801016c0:	83 ec 0c             	sub    $0xc,%esp
801016c3:	68 d8 77 10 80       	push   $0x801077d8
801016c8:	e8 b3 ec ff ff       	call   80100380 <panic>
801016cd:	8d 76 00             	lea    0x0(%esi),%esi

801016d0 <iupdate>:
{
801016d0:	55                   	push   %ebp
801016d1:	89 e5                	mov    %esp,%ebp
801016d3:	56                   	push   %esi
801016d4:	53                   	push   %ebx
801016d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016db:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016de:	83 ec 08             	sub    $0x8,%esp
801016e1:	c1 e8 03             	shr    $0x3,%eax
801016e4:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801016ea:	50                   	push   %eax
801016eb:	ff 73 a4             	push   -0x5c(%ebx)
801016ee:	e8 dd e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016f3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016f7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016fa:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016fc:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016ff:	83 e0 07             	and    $0x7,%eax
80101702:	c1 e0 06             	shl    $0x6,%eax
80101705:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101709:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010170c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101710:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101713:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101717:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010171b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010171f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101723:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101727:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010172a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010172d:	6a 34                	push   $0x34
8010172f:	53                   	push   %ebx
80101730:	50                   	push   %eax
80101731:	e8 ba 32 00 00       	call   801049f0 <memmove>
  log_write(bp);
80101736:	89 34 24             	mov    %esi,(%esp)
80101739:	e8 f2 1a 00 00       	call   80103230 <log_write>
  brelse(bp);
8010173e:	89 75 08             	mov    %esi,0x8(%ebp)
80101741:	83 c4 10             	add    $0x10,%esp
}
80101744:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101747:	5b                   	pop    %ebx
80101748:	5e                   	pop    %esi
80101749:	5d                   	pop    %ebp
  brelse(bp);
8010174a:	e9 a1 ea ff ff       	jmp    801001f0 <brelse>
8010174f:	90                   	nop

80101750 <idup>:
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	53                   	push   %ebx
80101754:	83 ec 10             	sub    $0x10,%esp
80101757:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010175a:	68 60 09 11 80       	push   $0x80110960
8010175f:	e8 2c 31 00 00       	call   80104890 <acquire>
  ip->ref++;
80101764:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101768:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010176f:	e8 bc 30 00 00       	call   80104830 <release>
}
80101774:	89 d8                	mov    %ebx,%eax
80101776:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101779:	c9                   	leave  
8010177a:	c3                   	ret    
8010177b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010177f:	90                   	nop

80101780 <ilock>:
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	56                   	push   %esi
80101784:	53                   	push   %ebx
80101785:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101788:	85 db                	test   %ebx,%ebx
8010178a:	0f 84 b7 00 00 00    	je     80101847 <ilock+0xc7>
80101790:	8b 53 08             	mov    0x8(%ebx),%edx
80101793:	85 d2                	test   %edx,%edx
80101795:	0f 8e ac 00 00 00    	jle    80101847 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010179b:	83 ec 0c             	sub    $0xc,%esp
8010179e:	8d 43 0c             	lea    0xc(%ebx),%eax
801017a1:	50                   	push   %eax
801017a2:	e8 29 2e 00 00       	call   801045d0 <acquiresleep>
  if(ip->valid == 0){
801017a7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017aa:	83 c4 10             	add    $0x10,%esp
801017ad:	85 c0                	test   %eax,%eax
801017af:	74 0f                	je     801017c0 <ilock+0x40>
}
801017b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017b4:	5b                   	pop    %ebx
801017b5:	5e                   	pop    %esi
801017b6:	5d                   	pop    %ebp
801017b7:	c3                   	ret    
801017b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017bf:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017c0:	8b 43 04             	mov    0x4(%ebx),%eax
801017c3:	83 ec 08             	sub    $0x8,%esp
801017c6:	c1 e8 03             	shr    $0x3,%eax
801017c9:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801017cf:	50                   	push   %eax
801017d0:	ff 33                	push   (%ebx)
801017d2:	e8 f9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017d7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017da:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017dc:	8b 43 04             	mov    0x4(%ebx),%eax
801017df:	83 e0 07             	and    $0x7,%eax
801017e2:	c1 e0 06             	shl    $0x6,%eax
801017e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017e9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017ec:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017ef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017f7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017ff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101803:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101807:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010180b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010180e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101811:	6a 34                	push   $0x34
80101813:	50                   	push   %eax
80101814:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101817:	50                   	push   %eax
80101818:	e8 d3 31 00 00       	call   801049f0 <memmove>
    brelse(bp);
8010181d:	89 34 24             	mov    %esi,(%esp)
80101820:	e8 cb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101825:	83 c4 10             	add    $0x10,%esp
80101828:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010182d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101834:	0f 85 77 ff ff ff    	jne    801017b1 <ilock+0x31>
      panic("ilock: no type");
8010183a:	83 ec 0c             	sub    $0xc,%esp
8010183d:	68 f0 77 10 80       	push   $0x801077f0
80101842:	e8 39 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101847:	83 ec 0c             	sub    $0xc,%esp
8010184a:	68 ea 77 10 80       	push   $0x801077ea
8010184f:	e8 2c eb ff ff       	call   80100380 <panic>
80101854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010185b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010185f:	90                   	nop

80101860 <iunlock>:
{
80101860:	55                   	push   %ebp
80101861:	89 e5                	mov    %esp,%ebp
80101863:	56                   	push   %esi
80101864:	53                   	push   %ebx
80101865:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101868:	85 db                	test   %ebx,%ebx
8010186a:	74 28                	je     80101894 <iunlock+0x34>
8010186c:	83 ec 0c             	sub    $0xc,%esp
8010186f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101872:	56                   	push   %esi
80101873:	e8 f8 2d 00 00       	call   80104670 <holdingsleep>
80101878:	83 c4 10             	add    $0x10,%esp
8010187b:	85 c0                	test   %eax,%eax
8010187d:	74 15                	je     80101894 <iunlock+0x34>
8010187f:	8b 43 08             	mov    0x8(%ebx),%eax
80101882:	85 c0                	test   %eax,%eax
80101884:	7e 0e                	jle    80101894 <iunlock+0x34>
  releasesleep(&ip->lock);
80101886:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101889:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010188c:	5b                   	pop    %ebx
8010188d:	5e                   	pop    %esi
8010188e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010188f:	e9 9c 2d 00 00       	jmp    80104630 <releasesleep>
    panic("iunlock");
80101894:	83 ec 0c             	sub    $0xc,%esp
80101897:	68 ff 77 10 80       	push   $0x801077ff
8010189c:	e8 df ea ff ff       	call   80100380 <panic>
801018a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018af:	90                   	nop

801018b0 <iput>:
{
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	57                   	push   %edi
801018b4:	56                   	push   %esi
801018b5:	53                   	push   %ebx
801018b6:	83 ec 28             	sub    $0x28,%esp
801018b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018bc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018bf:	57                   	push   %edi
801018c0:	e8 0b 2d 00 00       	call   801045d0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018c5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018c8:	83 c4 10             	add    $0x10,%esp
801018cb:	85 d2                	test   %edx,%edx
801018cd:	74 07                	je     801018d6 <iput+0x26>
801018cf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018d4:	74 32                	je     80101908 <iput+0x58>
  releasesleep(&ip->lock);
801018d6:	83 ec 0c             	sub    $0xc,%esp
801018d9:	57                   	push   %edi
801018da:	e8 51 2d 00 00       	call   80104630 <releasesleep>
  acquire(&icache.lock);
801018df:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801018e6:	e8 a5 2f 00 00       	call   80104890 <acquire>
  ip->ref--;
801018eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018ef:	83 c4 10             	add    $0x10,%esp
801018f2:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
}
801018f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018fc:	5b                   	pop    %ebx
801018fd:	5e                   	pop    %esi
801018fe:	5f                   	pop    %edi
801018ff:	5d                   	pop    %ebp
  release(&icache.lock);
80101900:	e9 2b 2f 00 00       	jmp    80104830 <release>
80101905:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101908:	83 ec 0c             	sub    $0xc,%esp
8010190b:	68 60 09 11 80       	push   $0x80110960
80101910:	e8 7b 2f 00 00       	call   80104890 <acquire>
    int r = ip->ref;
80101915:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101918:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010191f:	e8 0c 2f 00 00       	call   80104830 <release>
    if(r == 1){
80101924:	83 c4 10             	add    $0x10,%esp
80101927:	83 fe 01             	cmp    $0x1,%esi
8010192a:	75 aa                	jne    801018d6 <iput+0x26>
8010192c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101932:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101935:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101938:	89 cf                	mov    %ecx,%edi
8010193a:	eb 0b                	jmp    80101947 <iput+0x97>
8010193c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101940:	83 c6 04             	add    $0x4,%esi
80101943:	39 fe                	cmp    %edi,%esi
80101945:	74 19                	je     80101960 <iput+0xb0>
    if(ip->addrs[i]){
80101947:	8b 16                	mov    (%esi),%edx
80101949:	85 d2                	test   %edx,%edx
8010194b:	74 f3                	je     80101940 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010194d:	8b 03                	mov    (%ebx),%eax
8010194f:	e8 6c f8 ff ff       	call   801011c0 <bfree>
      ip->addrs[i] = 0;
80101954:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010195a:	eb e4                	jmp    80101940 <iput+0x90>
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101960:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101966:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101969:	85 c0                	test   %eax,%eax
8010196b:	75 2d                	jne    8010199a <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010196d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101970:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101977:	53                   	push   %ebx
80101978:	e8 53 fd ff ff       	call   801016d0 <iupdate>
      ip->type = 0;
8010197d:	31 c0                	xor    %eax,%eax
8010197f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101983:	89 1c 24             	mov    %ebx,(%esp)
80101986:	e8 45 fd ff ff       	call   801016d0 <iupdate>
      ip->valid = 0;
8010198b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101992:	83 c4 10             	add    $0x10,%esp
80101995:	e9 3c ff ff ff       	jmp    801018d6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
8010199a:	83 ec 08             	sub    $0x8,%esp
8010199d:	50                   	push   %eax
8010199e:	ff 33                	push   (%ebx)
801019a0:	e8 2b e7 ff ff       	call   801000d0 <bread>
801019a5:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019a8:	83 c4 10             	add    $0x10,%esp
801019ab:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019b4:	8d 70 5c             	lea    0x5c(%eax),%esi
801019b7:	89 cf                	mov    %ecx,%edi
801019b9:	eb 0c                	jmp    801019c7 <iput+0x117>
801019bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019bf:	90                   	nop
801019c0:	83 c6 04             	add    $0x4,%esi
801019c3:	39 f7                	cmp    %esi,%edi
801019c5:	74 0f                	je     801019d6 <iput+0x126>
      if(a[j])
801019c7:	8b 16                	mov    (%esi),%edx
801019c9:	85 d2                	test   %edx,%edx
801019cb:	74 f3                	je     801019c0 <iput+0x110>
        bfree(ip->dev, a[j]);
801019cd:	8b 03                	mov    (%ebx),%eax
801019cf:	e8 ec f7 ff ff       	call   801011c0 <bfree>
801019d4:	eb ea                	jmp    801019c0 <iput+0x110>
    brelse(bp);
801019d6:	83 ec 0c             	sub    $0xc,%esp
801019d9:	ff 75 e4             	push   -0x1c(%ebp)
801019dc:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019df:	e8 0c e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019e4:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019ea:	8b 03                	mov    (%ebx),%eax
801019ec:	e8 cf f7 ff ff       	call   801011c0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019f1:	83 c4 10             	add    $0x10,%esp
801019f4:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019fb:	00 00 00 
801019fe:	e9 6a ff ff ff       	jmp    8010196d <iput+0xbd>
80101a03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a10 <iunlockput>:
{
80101a10:	55                   	push   %ebp
80101a11:	89 e5                	mov    %esp,%ebp
80101a13:	56                   	push   %esi
80101a14:	53                   	push   %ebx
80101a15:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a18:	85 db                	test   %ebx,%ebx
80101a1a:	74 34                	je     80101a50 <iunlockput+0x40>
80101a1c:	83 ec 0c             	sub    $0xc,%esp
80101a1f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a22:	56                   	push   %esi
80101a23:	e8 48 2c 00 00       	call   80104670 <holdingsleep>
80101a28:	83 c4 10             	add    $0x10,%esp
80101a2b:	85 c0                	test   %eax,%eax
80101a2d:	74 21                	je     80101a50 <iunlockput+0x40>
80101a2f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a32:	85 c0                	test   %eax,%eax
80101a34:	7e 1a                	jle    80101a50 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a36:	83 ec 0c             	sub    $0xc,%esp
80101a39:	56                   	push   %esi
80101a3a:	e8 f1 2b 00 00       	call   80104630 <releasesleep>
  iput(ip);
80101a3f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a42:	83 c4 10             	add    $0x10,%esp
}
80101a45:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a48:	5b                   	pop    %ebx
80101a49:	5e                   	pop    %esi
80101a4a:	5d                   	pop    %ebp
  iput(ip);
80101a4b:	e9 60 fe ff ff       	jmp    801018b0 <iput>
    panic("iunlock");
80101a50:	83 ec 0c             	sub    $0xc,%esp
80101a53:	68 ff 77 10 80       	push   $0x801077ff
80101a58:	e8 23 e9 ff ff       	call   80100380 <panic>
80101a5d:	8d 76 00             	lea    0x0(%esi),%esi

80101a60 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	8b 55 08             	mov    0x8(%ebp),%edx
80101a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a69:	8b 0a                	mov    (%edx),%ecx
80101a6b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a6e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a71:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a74:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a78:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a7b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a7f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a83:	8b 52 58             	mov    0x58(%edx),%edx
80101a86:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a89:	5d                   	pop    %ebp
80101a8a:	c3                   	ret    
80101a8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a8f:	90                   	nop

80101a90 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a90:	55                   	push   %ebp
80101a91:	89 e5                	mov    %esp,%ebp
80101a93:	57                   	push   %edi
80101a94:	56                   	push   %esi
80101a95:	53                   	push   %ebx
80101a96:	83 ec 1c             	sub    $0x1c,%esp
80101a99:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a9c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9f:	8b 75 10             	mov    0x10(%ebp),%esi
80101aa2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101aa5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101aa8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101aad:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ab0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101ab3:	0f 84 a7 00 00 00    	je     80101b60 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ab9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101abc:	8b 40 58             	mov    0x58(%eax),%eax
80101abf:	39 c6                	cmp    %eax,%esi
80101ac1:	0f 87 ba 00 00 00    	ja     80101b81 <readi+0xf1>
80101ac7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101aca:	31 c9                	xor    %ecx,%ecx
80101acc:	89 da                	mov    %ebx,%edx
80101ace:	01 f2                	add    %esi,%edx
80101ad0:	0f 92 c1             	setb   %cl
80101ad3:	89 cf                	mov    %ecx,%edi
80101ad5:	0f 82 a6 00 00 00    	jb     80101b81 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101adb:	89 c1                	mov    %eax,%ecx
80101add:	29 f1                	sub    %esi,%ecx
80101adf:	39 d0                	cmp    %edx,%eax
80101ae1:	0f 43 cb             	cmovae %ebx,%ecx
80101ae4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ae7:	85 c9                	test   %ecx,%ecx
80101ae9:	74 67                	je     80101b52 <readi+0xc2>
80101aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101af3:	89 f2                	mov    %esi,%edx
80101af5:	c1 ea 09             	shr    $0x9,%edx
80101af8:	89 d8                	mov    %ebx,%eax
80101afa:	e8 51 f9 ff ff       	call   80101450 <bmap>
80101aff:	83 ec 08             	sub    $0x8,%esp
80101b02:	50                   	push   %eax
80101b03:	ff 33                	push   (%ebx)
80101b05:	e8 c6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b0a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b0d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b12:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b14:	89 f0                	mov    %esi,%eax
80101b16:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b1b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b1d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b20:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b22:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b26:	39 d9                	cmp    %ebx,%ecx
80101b28:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b2b:	83 c4 0c             	add    $0xc,%esp
80101b2e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b2f:	01 df                	add    %ebx,%edi
80101b31:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b33:	50                   	push   %eax
80101b34:	ff 75 e0             	push   -0x20(%ebp)
80101b37:	e8 b4 2e 00 00       	call   801049f0 <memmove>
    brelse(bp);
80101b3c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b3f:	89 14 24             	mov    %edx,(%esp)
80101b42:	e8 a9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b47:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b4a:	83 c4 10             	add    $0x10,%esp
80101b4d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b50:	77 9e                	ja     80101af0 <readi+0x60>
  }
  return n;
80101b52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b58:	5b                   	pop    %ebx
80101b59:	5e                   	pop    %esi
80101b5a:	5f                   	pop    %edi
80101b5b:	5d                   	pop    %ebp
80101b5c:	c3                   	ret    
80101b5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b64:	66 83 f8 09          	cmp    $0x9,%ax
80101b68:	77 17                	ja     80101b81 <readi+0xf1>
80101b6a:	8b 04 c5 00 09 11 80 	mov    -0x7feef700(,%eax,8),%eax
80101b71:	85 c0                	test   %eax,%eax
80101b73:	74 0c                	je     80101b81 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b75:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b7b:	5b                   	pop    %ebx
80101b7c:	5e                   	pop    %esi
80101b7d:	5f                   	pop    %edi
80101b7e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b7f:	ff e0                	jmp    *%eax
      return -1;
80101b81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b86:	eb cd                	jmp    80101b55 <readi+0xc5>
80101b88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b8f:	90                   	nop

80101b90 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	57                   	push   %edi
80101b94:	56                   	push   %esi
80101b95:	53                   	push   %ebx
80101b96:	83 ec 1c             	sub    $0x1c,%esp
80101b99:	8b 45 08             	mov    0x8(%ebp),%eax
80101b9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b9f:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ba2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101ba7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101baa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bad:	8b 75 10             	mov    0x10(%ebp),%esi
80101bb0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101bb3:	0f 84 b7 00 00 00    	je     80101c70 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bb9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bbc:	3b 70 58             	cmp    0x58(%eax),%esi
80101bbf:	0f 87 e7 00 00 00    	ja     80101cac <writei+0x11c>
80101bc5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bc8:	31 d2                	xor    %edx,%edx
80101bca:	89 f8                	mov    %edi,%eax
80101bcc:	01 f0                	add    %esi,%eax
80101bce:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101bd1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bd6:	0f 87 d0 00 00 00    	ja     80101cac <writei+0x11c>
80101bdc:	85 d2                	test   %edx,%edx
80101bde:	0f 85 c8 00 00 00    	jne    80101cac <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101be4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101beb:	85 ff                	test   %edi,%edi
80101bed:	74 72                	je     80101c61 <writei+0xd1>
80101bef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bf0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bf3:	89 f2                	mov    %esi,%edx
80101bf5:	c1 ea 09             	shr    $0x9,%edx
80101bf8:	89 f8                	mov    %edi,%eax
80101bfa:	e8 51 f8 ff ff       	call   80101450 <bmap>
80101bff:	83 ec 08             	sub    $0x8,%esp
80101c02:	50                   	push   %eax
80101c03:	ff 37                	push   (%edi)
80101c05:	e8 c6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c0a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c0f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c12:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c15:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c17:	89 f0                	mov    %esi,%eax
80101c19:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c1e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c20:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c24:	39 d9                	cmp    %ebx,%ecx
80101c26:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c29:	83 c4 0c             	add    $0xc,%esp
80101c2c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c2d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c2f:	ff 75 dc             	push   -0x24(%ebp)
80101c32:	50                   	push   %eax
80101c33:	e8 b8 2d 00 00       	call   801049f0 <memmove>
    log_write(bp);
80101c38:	89 3c 24             	mov    %edi,(%esp)
80101c3b:	e8 f0 15 00 00       	call   80103230 <log_write>
    brelse(bp);
80101c40:	89 3c 24             	mov    %edi,(%esp)
80101c43:	e8 a8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c48:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c4b:	83 c4 10             	add    $0x10,%esp
80101c4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c51:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c54:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c57:	77 97                	ja     80101bf0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c5c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c5f:	77 37                	ja     80101c98 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c61:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c67:	5b                   	pop    %ebx
80101c68:	5e                   	pop    %esi
80101c69:	5f                   	pop    %edi
80101c6a:	5d                   	pop    %ebp
80101c6b:	c3                   	ret    
80101c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c74:	66 83 f8 09          	cmp    $0x9,%ax
80101c78:	77 32                	ja     80101cac <writei+0x11c>
80101c7a:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
80101c81:	85 c0                	test   %eax,%eax
80101c83:	74 27                	je     80101cac <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c85:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c8b:	5b                   	pop    %ebx
80101c8c:	5e                   	pop    %esi
80101c8d:	5f                   	pop    %edi
80101c8e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c8f:	ff e0                	jmp    *%eax
80101c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c98:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c9b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c9e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101ca1:	50                   	push   %eax
80101ca2:	e8 29 fa ff ff       	call   801016d0 <iupdate>
80101ca7:	83 c4 10             	add    $0x10,%esp
80101caa:	eb b5                	jmp    80101c61 <writei+0xd1>
      return -1;
80101cac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cb1:	eb b1                	jmp    80101c64 <writei+0xd4>
80101cb3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101cc0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101cc0:	55                   	push   %ebp
80101cc1:	89 e5                	mov    %esp,%ebp
80101cc3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cc6:	6a 0e                	push   $0xe
80101cc8:	ff 75 0c             	push   0xc(%ebp)
80101ccb:	ff 75 08             	push   0x8(%ebp)
80101cce:	e8 8d 2d 00 00       	call   80104a60 <strncmp>
}
80101cd3:	c9                   	leave  
80101cd4:	c3                   	ret    
80101cd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ce0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101ce0:	55                   	push   %ebp
80101ce1:	89 e5                	mov    %esp,%ebp
80101ce3:	57                   	push   %edi
80101ce4:	56                   	push   %esi
80101ce5:	53                   	push   %ebx
80101ce6:	83 ec 1c             	sub    $0x1c,%esp
80101ce9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cf1:	0f 85 85 00 00 00    	jne    80101d7c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101cf7:	8b 53 58             	mov    0x58(%ebx),%edx
80101cfa:	31 ff                	xor    %edi,%edi
80101cfc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101cff:	85 d2                	test   %edx,%edx
80101d01:	74 3e                	je     80101d41 <dirlookup+0x61>
80101d03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d07:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d08:	6a 10                	push   $0x10
80101d0a:	57                   	push   %edi
80101d0b:	56                   	push   %esi
80101d0c:	53                   	push   %ebx
80101d0d:	e8 7e fd ff ff       	call   80101a90 <readi>
80101d12:	83 c4 10             	add    $0x10,%esp
80101d15:	83 f8 10             	cmp    $0x10,%eax
80101d18:	75 55                	jne    80101d6f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d1a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d1f:	74 18                	je     80101d39 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d21:	83 ec 04             	sub    $0x4,%esp
80101d24:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d27:	6a 0e                	push   $0xe
80101d29:	50                   	push   %eax
80101d2a:	ff 75 0c             	push   0xc(%ebp)
80101d2d:	e8 2e 2d 00 00       	call   80104a60 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d32:	83 c4 10             	add    $0x10,%esp
80101d35:	85 c0                	test   %eax,%eax
80101d37:	74 17                	je     80101d50 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d39:	83 c7 10             	add    $0x10,%edi
80101d3c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d3f:	72 c7                	jb     80101d08 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d44:	31 c0                	xor    %eax,%eax
}
80101d46:	5b                   	pop    %ebx
80101d47:	5e                   	pop    %esi
80101d48:	5f                   	pop    %edi
80101d49:	5d                   	pop    %ebp
80101d4a:	c3                   	ret    
80101d4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d4f:	90                   	nop
      if(poff)
80101d50:	8b 45 10             	mov    0x10(%ebp),%eax
80101d53:	85 c0                	test   %eax,%eax
80101d55:	74 05                	je     80101d5c <dirlookup+0x7c>
        *poff = off;
80101d57:	8b 45 10             	mov    0x10(%ebp),%eax
80101d5a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d5c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d60:	8b 03                	mov    (%ebx),%eax
80101d62:	e8 e9 f5 ff ff       	call   80101350 <iget>
}
80101d67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d6a:	5b                   	pop    %ebx
80101d6b:	5e                   	pop    %esi
80101d6c:	5f                   	pop    %edi
80101d6d:	5d                   	pop    %ebp
80101d6e:	c3                   	ret    
      panic("dirlookup read");
80101d6f:	83 ec 0c             	sub    $0xc,%esp
80101d72:	68 19 78 10 80       	push   $0x80107819
80101d77:	e8 04 e6 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d7c:	83 ec 0c             	sub    $0xc,%esp
80101d7f:	68 07 78 10 80       	push   $0x80107807
80101d84:	e8 f7 e5 ff ff       	call   80100380 <panic>
80101d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d90 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d90:	55                   	push   %ebp
80101d91:	89 e5                	mov    %esp,%ebp
80101d93:	57                   	push   %edi
80101d94:	56                   	push   %esi
80101d95:	53                   	push   %ebx
80101d96:	89 c3                	mov    %eax,%ebx
80101d98:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d9b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d9e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101da1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101da4:	0f 84 64 01 00 00    	je     80101f0e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101daa:	e8 b1 1e 00 00       	call   80103c60 <myproc>
  acquire(&icache.lock);
80101daf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101db2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101db5:	68 60 09 11 80       	push   $0x80110960
80101dba:	e8 d1 2a 00 00       	call   80104890 <acquire>
  ip->ref++;
80101dbf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dc3:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101dca:	e8 61 2a 00 00       	call   80104830 <release>
80101dcf:	83 c4 10             	add    $0x10,%esp
80101dd2:	eb 07                	jmp    80101ddb <namex+0x4b>
80101dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101dd8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ddb:	0f b6 03             	movzbl (%ebx),%eax
80101dde:	3c 2f                	cmp    $0x2f,%al
80101de0:	74 f6                	je     80101dd8 <namex+0x48>
  if(*path == 0)
80101de2:	84 c0                	test   %al,%al
80101de4:	0f 84 06 01 00 00    	je     80101ef0 <namex+0x160>
  while(*path != '/' && *path != 0)
80101dea:	0f b6 03             	movzbl (%ebx),%eax
80101ded:	84 c0                	test   %al,%al
80101def:	0f 84 10 01 00 00    	je     80101f05 <namex+0x175>
80101df5:	89 df                	mov    %ebx,%edi
80101df7:	3c 2f                	cmp    $0x2f,%al
80101df9:	0f 84 06 01 00 00    	je     80101f05 <namex+0x175>
80101dff:	90                   	nop
80101e00:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e04:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	74 04                	je     80101e0f <namex+0x7f>
80101e0b:	84 c0                	test   %al,%al
80101e0d:	75 f1                	jne    80101e00 <namex+0x70>
  len = path - s;
80101e0f:	89 f8                	mov    %edi,%eax
80101e11:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e13:	83 f8 0d             	cmp    $0xd,%eax
80101e16:	0f 8e ac 00 00 00    	jle    80101ec8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e1c:	83 ec 04             	sub    $0x4,%esp
80101e1f:	6a 0e                	push   $0xe
80101e21:	53                   	push   %ebx
    path++;
80101e22:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101e24:	ff 75 e4             	push   -0x1c(%ebp)
80101e27:	e8 c4 2b 00 00       	call   801049f0 <memmove>
80101e2c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e2f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e32:	75 0c                	jne    80101e40 <namex+0xb0>
80101e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e38:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e3b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e3e:	74 f8                	je     80101e38 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e40:	83 ec 0c             	sub    $0xc,%esp
80101e43:	56                   	push   %esi
80101e44:	e8 37 f9 ff ff       	call   80101780 <ilock>
    if(ip->type != T_DIR){
80101e49:	83 c4 10             	add    $0x10,%esp
80101e4c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e51:	0f 85 cd 00 00 00    	jne    80101f24 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e57:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e5a:	85 c0                	test   %eax,%eax
80101e5c:	74 09                	je     80101e67 <namex+0xd7>
80101e5e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e61:	0f 84 22 01 00 00    	je     80101f89 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e67:	83 ec 04             	sub    $0x4,%esp
80101e6a:	6a 00                	push   $0x0
80101e6c:	ff 75 e4             	push   -0x1c(%ebp)
80101e6f:	56                   	push   %esi
80101e70:	e8 6b fe ff ff       	call   80101ce0 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e75:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101e78:	83 c4 10             	add    $0x10,%esp
80101e7b:	89 c7                	mov    %eax,%edi
80101e7d:	85 c0                	test   %eax,%eax
80101e7f:	0f 84 e1 00 00 00    	je     80101f66 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e85:	83 ec 0c             	sub    $0xc,%esp
80101e88:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101e8b:	52                   	push   %edx
80101e8c:	e8 df 27 00 00       	call   80104670 <holdingsleep>
80101e91:	83 c4 10             	add    $0x10,%esp
80101e94:	85 c0                	test   %eax,%eax
80101e96:	0f 84 30 01 00 00    	je     80101fcc <namex+0x23c>
80101e9c:	8b 56 08             	mov    0x8(%esi),%edx
80101e9f:	85 d2                	test   %edx,%edx
80101ea1:	0f 8e 25 01 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101ea7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101eaa:	83 ec 0c             	sub    $0xc,%esp
80101ead:	52                   	push   %edx
80101eae:	e8 7d 27 00 00       	call   80104630 <releasesleep>
  iput(ip);
80101eb3:	89 34 24             	mov    %esi,(%esp)
80101eb6:	89 fe                	mov    %edi,%esi
80101eb8:	e8 f3 f9 ff ff       	call   801018b0 <iput>
80101ebd:	83 c4 10             	add    $0x10,%esp
80101ec0:	e9 16 ff ff ff       	jmp    80101ddb <namex+0x4b>
80101ec5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ec8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101ecb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101ece:	83 ec 04             	sub    $0x4,%esp
80101ed1:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101ed4:	50                   	push   %eax
80101ed5:	53                   	push   %ebx
    name[len] = 0;
80101ed6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101ed8:	ff 75 e4             	push   -0x1c(%ebp)
80101edb:	e8 10 2b 00 00       	call   801049f0 <memmove>
    name[len] = 0;
80101ee0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101ee3:	83 c4 10             	add    $0x10,%esp
80101ee6:	c6 02 00             	movb   $0x0,(%edx)
80101ee9:	e9 41 ff ff ff       	jmp    80101e2f <namex+0x9f>
80101eee:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ef0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101ef3:	85 c0                	test   %eax,%eax
80101ef5:	0f 85 be 00 00 00    	jne    80101fb9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
80101efb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101efe:	89 f0                	mov    %esi,%eax
80101f00:	5b                   	pop    %ebx
80101f01:	5e                   	pop    %esi
80101f02:	5f                   	pop    %edi
80101f03:	5d                   	pop    %ebp
80101f04:	c3                   	ret    
  while(*path != '/' && *path != 0)
80101f05:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f08:	89 df                	mov    %ebx,%edi
80101f0a:	31 c0                	xor    %eax,%eax
80101f0c:	eb c0                	jmp    80101ece <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
80101f0e:	ba 01 00 00 00       	mov    $0x1,%edx
80101f13:	b8 01 00 00 00       	mov    $0x1,%eax
80101f18:	e8 33 f4 ff ff       	call   80101350 <iget>
80101f1d:	89 c6                	mov    %eax,%esi
80101f1f:	e9 b7 fe ff ff       	jmp    80101ddb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f24:	83 ec 0c             	sub    $0xc,%esp
80101f27:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f2a:	53                   	push   %ebx
80101f2b:	e8 40 27 00 00       	call   80104670 <holdingsleep>
80101f30:	83 c4 10             	add    $0x10,%esp
80101f33:	85 c0                	test   %eax,%eax
80101f35:	0f 84 91 00 00 00    	je     80101fcc <namex+0x23c>
80101f3b:	8b 46 08             	mov    0x8(%esi),%eax
80101f3e:	85 c0                	test   %eax,%eax
80101f40:	0f 8e 86 00 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f46:	83 ec 0c             	sub    $0xc,%esp
80101f49:	53                   	push   %ebx
80101f4a:	e8 e1 26 00 00       	call   80104630 <releasesleep>
  iput(ip);
80101f4f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f52:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f54:	e8 57 f9 ff ff       	call   801018b0 <iput>
      return 0;
80101f59:	83 c4 10             	add    $0x10,%esp
}
80101f5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f5f:	89 f0                	mov    %esi,%eax
80101f61:	5b                   	pop    %ebx
80101f62:	5e                   	pop    %esi
80101f63:	5f                   	pop    %edi
80101f64:	5d                   	pop    %ebp
80101f65:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f66:	83 ec 0c             	sub    $0xc,%esp
80101f69:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101f6c:	52                   	push   %edx
80101f6d:	e8 fe 26 00 00       	call   80104670 <holdingsleep>
80101f72:	83 c4 10             	add    $0x10,%esp
80101f75:	85 c0                	test   %eax,%eax
80101f77:	74 53                	je     80101fcc <namex+0x23c>
80101f79:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f7c:	85 c9                	test   %ecx,%ecx
80101f7e:	7e 4c                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f80:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f83:	83 ec 0c             	sub    $0xc,%esp
80101f86:	52                   	push   %edx
80101f87:	eb c1                	jmp    80101f4a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f89:	83 ec 0c             	sub    $0xc,%esp
80101f8c:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f8f:	53                   	push   %ebx
80101f90:	e8 db 26 00 00       	call   80104670 <holdingsleep>
80101f95:	83 c4 10             	add    $0x10,%esp
80101f98:	85 c0                	test   %eax,%eax
80101f9a:	74 30                	je     80101fcc <namex+0x23c>
80101f9c:	8b 7e 08             	mov    0x8(%esi),%edi
80101f9f:	85 ff                	test   %edi,%edi
80101fa1:	7e 29                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101fa3:	83 ec 0c             	sub    $0xc,%esp
80101fa6:	53                   	push   %ebx
80101fa7:	e8 84 26 00 00       	call   80104630 <releasesleep>
}
80101fac:	83 c4 10             	add    $0x10,%esp
}
80101faf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fb2:	89 f0                	mov    %esi,%eax
80101fb4:	5b                   	pop    %ebx
80101fb5:	5e                   	pop    %esi
80101fb6:	5f                   	pop    %edi
80101fb7:	5d                   	pop    %ebp
80101fb8:	c3                   	ret    
    iput(ip);
80101fb9:	83 ec 0c             	sub    $0xc,%esp
80101fbc:	56                   	push   %esi
    return 0;
80101fbd:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fbf:	e8 ec f8 ff ff       	call   801018b0 <iput>
    return 0;
80101fc4:	83 c4 10             	add    $0x10,%esp
80101fc7:	e9 2f ff ff ff       	jmp    80101efb <namex+0x16b>
    panic("iunlock");
80101fcc:	83 ec 0c             	sub    $0xc,%esp
80101fcf:	68 ff 77 10 80       	push   $0x801077ff
80101fd4:	e8 a7 e3 ff ff       	call   80100380 <panic>
80101fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101fe0 <dirlink>:
{
80101fe0:	55                   	push   %ebp
80101fe1:	89 e5                	mov    %esp,%ebp
80101fe3:	57                   	push   %edi
80101fe4:	56                   	push   %esi
80101fe5:	53                   	push   %ebx
80101fe6:	83 ec 20             	sub    $0x20,%esp
80101fe9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101fec:	6a 00                	push   $0x0
80101fee:	ff 75 0c             	push   0xc(%ebp)
80101ff1:	53                   	push   %ebx
80101ff2:	e8 e9 fc ff ff       	call   80101ce0 <dirlookup>
80101ff7:	83 c4 10             	add    $0x10,%esp
80101ffa:	85 c0                	test   %eax,%eax
80101ffc:	75 67                	jne    80102065 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ffe:	8b 7b 58             	mov    0x58(%ebx),%edi
80102001:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102004:	85 ff                	test   %edi,%edi
80102006:	74 29                	je     80102031 <dirlink+0x51>
80102008:	31 ff                	xor    %edi,%edi
8010200a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010200d:	eb 09                	jmp    80102018 <dirlink+0x38>
8010200f:	90                   	nop
80102010:	83 c7 10             	add    $0x10,%edi
80102013:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102016:	73 19                	jae    80102031 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102018:	6a 10                	push   $0x10
8010201a:	57                   	push   %edi
8010201b:	56                   	push   %esi
8010201c:	53                   	push   %ebx
8010201d:	e8 6e fa ff ff       	call   80101a90 <readi>
80102022:	83 c4 10             	add    $0x10,%esp
80102025:	83 f8 10             	cmp    $0x10,%eax
80102028:	75 4e                	jne    80102078 <dirlink+0x98>
    if(de.inum == 0)
8010202a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010202f:	75 df                	jne    80102010 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102031:	83 ec 04             	sub    $0x4,%esp
80102034:	8d 45 da             	lea    -0x26(%ebp),%eax
80102037:	6a 0e                	push   $0xe
80102039:	ff 75 0c             	push   0xc(%ebp)
8010203c:	50                   	push   %eax
8010203d:	e8 6e 2a 00 00       	call   80104ab0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102042:	6a 10                	push   $0x10
  de.inum = inum;
80102044:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102047:	57                   	push   %edi
80102048:	56                   	push   %esi
80102049:	53                   	push   %ebx
  de.inum = inum;
8010204a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010204e:	e8 3d fb ff ff       	call   80101b90 <writei>
80102053:	83 c4 20             	add    $0x20,%esp
80102056:	83 f8 10             	cmp    $0x10,%eax
80102059:	75 2a                	jne    80102085 <dirlink+0xa5>
  return 0;
8010205b:	31 c0                	xor    %eax,%eax
}
8010205d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102060:	5b                   	pop    %ebx
80102061:	5e                   	pop    %esi
80102062:	5f                   	pop    %edi
80102063:	5d                   	pop    %ebp
80102064:	c3                   	ret    
    iput(ip);
80102065:	83 ec 0c             	sub    $0xc,%esp
80102068:	50                   	push   %eax
80102069:	e8 42 f8 ff ff       	call   801018b0 <iput>
    return -1;
8010206e:	83 c4 10             	add    $0x10,%esp
80102071:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102076:	eb e5                	jmp    8010205d <dirlink+0x7d>
      panic("dirlink read");
80102078:	83 ec 0c             	sub    $0xc,%esp
8010207b:	68 28 78 10 80       	push   $0x80107828
80102080:	e8 fb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102085:	83 ec 0c             	sub    $0xc,%esp
80102088:	68 2e 7e 10 80       	push   $0x80107e2e
8010208d:	e8 ee e2 ff ff       	call   80100380 <panic>
80102092:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020a0 <namei>:

struct inode*
namei(char *path)
{
801020a0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020a1:	31 d2                	xor    %edx,%edx
{
801020a3:	89 e5                	mov    %esp,%ebp
801020a5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020a8:	8b 45 08             	mov    0x8(%ebp),%eax
801020ab:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020ae:	e8 dd fc ff ff       	call   80101d90 <namex>
}
801020b3:	c9                   	leave  
801020b4:	c3                   	ret    
801020b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020c0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020c0:	55                   	push   %ebp
  return namex(path, 1, name);
801020c1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020c6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020cb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020ce:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020cf:	e9 bc fc ff ff       	jmp    80101d90 <namex>
801020d4:	66 90                	xchg   %ax,%ax
801020d6:	66 90                	xchg   %ax,%ax
801020d8:	66 90                	xchg   %ax,%ax
801020da:	66 90                	xchg   %ax,%ax
801020dc:	66 90                	xchg   %ax,%ax
801020de:	66 90                	xchg   %ax,%ax

801020e0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	57                   	push   %edi
801020e4:	56                   	push   %esi
801020e5:	53                   	push   %ebx
801020e6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020e9:	85 c0                	test   %eax,%eax
801020eb:	0f 84 b4 00 00 00    	je     801021a5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801020f1:	8b 70 08             	mov    0x8(%eax),%esi
801020f4:	89 c3                	mov    %eax,%ebx
801020f6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801020fc:	0f 87 96 00 00 00    	ja     80102198 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102102:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010210e:	66 90                	xchg   %ax,%ax
80102110:	89 ca                	mov    %ecx,%edx
80102112:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102113:	83 e0 c0             	and    $0xffffffc0,%eax
80102116:	3c 40                	cmp    $0x40,%al
80102118:	75 f6                	jne    80102110 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010211a:	31 ff                	xor    %edi,%edi
8010211c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102121:	89 f8                	mov    %edi,%eax
80102123:	ee                   	out    %al,(%dx)
80102124:	b8 01 00 00 00       	mov    $0x1,%eax
80102129:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010212e:	ee                   	out    %al,(%dx)
8010212f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102134:	89 f0                	mov    %esi,%eax
80102136:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102137:	89 f0                	mov    %esi,%eax
80102139:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010213e:	c1 f8 08             	sar    $0x8,%eax
80102141:	ee                   	out    %al,(%dx)
80102142:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102147:	89 f8                	mov    %edi,%eax
80102149:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010214a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010214e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102153:	c1 e0 04             	shl    $0x4,%eax
80102156:	83 e0 10             	and    $0x10,%eax
80102159:	83 c8 e0             	or     $0xffffffe0,%eax
8010215c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010215d:	f6 03 04             	testb  $0x4,(%ebx)
80102160:	75 16                	jne    80102178 <idestart+0x98>
80102162:	b8 20 00 00 00       	mov    $0x20,%eax
80102167:	89 ca                	mov    %ecx,%edx
80102169:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010216a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010216d:	5b                   	pop    %ebx
8010216e:	5e                   	pop    %esi
8010216f:	5f                   	pop    %edi
80102170:	5d                   	pop    %ebp
80102171:	c3                   	ret    
80102172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102178:	b8 30 00 00 00       	mov    $0x30,%eax
8010217d:	89 ca                	mov    %ecx,%edx
8010217f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102180:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102185:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102188:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010218d:	fc                   	cld    
8010218e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102190:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102193:	5b                   	pop    %ebx
80102194:	5e                   	pop    %esi
80102195:	5f                   	pop    %edi
80102196:	5d                   	pop    %ebp
80102197:	c3                   	ret    
    panic("incorrect blockno");
80102198:	83 ec 0c             	sub    $0xc,%esp
8010219b:	68 94 78 10 80       	push   $0x80107894
801021a0:	e8 db e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021a5:	83 ec 0c             	sub    $0xc,%esp
801021a8:	68 8b 78 10 80       	push   $0x8010788b
801021ad:	e8 ce e1 ff ff       	call   80100380 <panic>
801021b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021c0 <ideinit>:
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021c6:	68 a6 78 10 80       	push   $0x801078a6
801021cb:	68 00 26 11 80       	push   $0x80112600
801021d0:	e8 eb 24 00 00       	call   801046c0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021d5:	58                   	pop    %eax
801021d6:	a1 84 a7 14 80       	mov    0x8014a784,%eax
801021db:	5a                   	pop    %edx
801021dc:	83 e8 01             	sub    $0x1,%eax
801021df:	50                   	push   %eax
801021e0:	6a 0e                	push   $0xe
801021e2:	e8 99 02 00 00       	call   80102480 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021e7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021ea:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021ef:	90                   	nop
801021f0:	ec                   	in     (%dx),%al
801021f1:	83 e0 c0             	and    $0xffffffc0,%eax
801021f4:	3c 40                	cmp    $0x40,%al
801021f6:	75 f8                	jne    801021f0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021f8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021fd:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102202:	ee                   	out    %al,(%dx)
80102203:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102208:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010220d:	eb 06                	jmp    80102215 <ideinit+0x55>
8010220f:	90                   	nop
  for(i=0; i<1000; i++){
80102210:	83 e9 01             	sub    $0x1,%ecx
80102213:	74 0f                	je     80102224 <ideinit+0x64>
80102215:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102216:	84 c0                	test   %al,%al
80102218:	74 f6                	je     80102210 <ideinit+0x50>
      havedisk1 = 1;
8010221a:	c7 05 e0 25 11 80 01 	movl   $0x1,0x801125e0
80102221:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102224:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102229:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010222e:	ee                   	out    %al,(%dx)
}
8010222f:	c9                   	leave  
80102230:	c3                   	ret    
80102231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010223f:	90                   	nop

80102240 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102240:	55                   	push   %ebp
80102241:	89 e5                	mov    %esp,%ebp
80102243:	57                   	push   %edi
80102244:	56                   	push   %esi
80102245:	53                   	push   %ebx
80102246:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102249:	68 00 26 11 80       	push   $0x80112600
8010224e:	e8 3d 26 00 00       	call   80104890 <acquire>

  if((b = idequeue) == 0){
80102253:	8b 1d e4 25 11 80    	mov    0x801125e4,%ebx
80102259:	83 c4 10             	add    $0x10,%esp
8010225c:	85 db                	test   %ebx,%ebx
8010225e:	74 63                	je     801022c3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102260:	8b 43 58             	mov    0x58(%ebx),%eax
80102263:	a3 e4 25 11 80       	mov    %eax,0x801125e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102268:	8b 33                	mov    (%ebx),%esi
8010226a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102270:	75 2f                	jne    801022a1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102272:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010227e:	66 90                	xchg   %ax,%ax
80102280:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102281:	89 c1                	mov    %eax,%ecx
80102283:	83 e1 c0             	and    $0xffffffc0,%ecx
80102286:	80 f9 40             	cmp    $0x40,%cl
80102289:	75 f5                	jne    80102280 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010228b:	a8 21                	test   $0x21,%al
8010228d:	75 12                	jne    801022a1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010228f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102292:	b9 80 00 00 00       	mov    $0x80,%ecx
80102297:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010229c:	fc                   	cld    
8010229d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010229f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801022a1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801022a4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801022a7:	83 ce 02             	or     $0x2,%esi
801022aa:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801022ac:	53                   	push   %ebx
801022ad:	e8 3e 21 00 00       	call   801043f0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022b2:	a1 e4 25 11 80       	mov    0x801125e4,%eax
801022b7:	83 c4 10             	add    $0x10,%esp
801022ba:	85 c0                	test   %eax,%eax
801022bc:	74 05                	je     801022c3 <ideintr+0x83>
    idestart(idequeue);
801022be:	e8 1d fe ff ff       	call   801020e0 <idestart>
    release(&idelock);
801022c3:	83 ec 0c             	sub    $0xc,%esp
801022c6:	68 00 26 11 80       	push   $0x80112600
801022cb:	e8 60 25 00 00       	call   80104830 <release>

  release(&idelock);
}
801022d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022d3:	5b                   	pop    %ebx
801022d4:	5e                   	pop    %esi
801022d5:	5f                   	pop    %edi
801022d6:	5d                   	pop    %ebp
801022d7:	c3                   	ret    
801022d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022df:	90                   	nop

801022e0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	53                   	push   %ebx
801022e4:	83 ec 10             	sub    $0x10,%esp
801022e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022ea:	8d 43 0c             	lea    0xc(%ebx),%eax
801022ed:	50                   	push   %eax
801022ee:	e8 7d 23 00 00       	call   80104670 <holdingsleep>
801022f3:	83 c4 10             	add    $0x10,%esp
801022f6:	85 c0                	test   %eax,%eax
801022f8:	0f 84 c3 00 00 00    	je     801023c1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022fe:	8b 03                	mov    (%ebx),%eax
80102300:	83 e0 06             	and    $0x6,%eax
80102303:	83 f8 02             	cmp    $0x2,%eax
80102306:	0f 84 a8 00 00 00    	je     801023b4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010230c:	8b 53 04             	mov    0x4(%ebx),%edx
8010230f:	85 d2                	test   %edx,%edx
80102311:	74 0d                	je     80102320 <iderw+0x40>
80102313:	a1 e0 25 11 80       	mov    0x801125e0,%eax
80102318:	85 c0                	test   %eax,%eax
8010231a:	0f 84 87 00 00 00    	je     801023a7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102320:	83 ec 0c             	sub    $0xc,%esp
80102323:	68 00 26 11 80       	push   $0x80112600
80102328:	e8 63 25 00 00       	call   80104890 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010232d:	a1 e4 25 11 80       	mov    0x801125e4,%eax
  b->qnext = 0;
80102332:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102339:	83 c4 10             	add    $0x10,%esp
8010233c:	85 c0                	test   %eax,%eax
8010233e:	74 60                	je     801023a0 <iderw+0xc0>
80102340:	89 c2                	mov    %eax,%edx
80102342:	8b 40 58             	mov    0x58(%eax),%eax
80102345:	85 c0                	test   %eax,%eax
80102347:	75 f7                	jne    80102340 <iderw+0x60>
80102349:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010234c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010234e:	39 1d e4 25 11 80    	cmp    %ebx,0x801125e4
80102354:	74 3a                	je     80102390 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102356:	8b 03                	mov    (%ebx),%eax
80102358:	83 e0 06             	and    $0x6,%eax
8010235b:	83 f8 02             	cmp    $0x2,%eax
8010235e:	74 1b                	je     8010237b <iderw+0x9b>
    sleep(b, &idelock);
80102360:	83 ec 08             	sub    $0x8,%esp
80102363:	68 00 26 11 80       	push   $0x80112600
80102368:	53                   	push   %ebx
80102369:	e8 c2 1f 00 00       	call   80104330 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010236e:	8b 03                	mov    (%ebx),%eax
80102370:	83 c4 10             	add    $0x10,%esp
80102373:	83 e0 06             	and    $0x6,%eax
80102376:	83 f8 02             	cmp    $0x2,%eax
80102379:	75 e5                	jne    80102360 <iderw+0x80>
  }


  release(&idelock);
8010237b:	c7 45 08 00 26 11 80 	movl   $0x80112600,0x8(%ebp)
}
80102382:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102385:	c9                   	leave  
  release(&idelock);
80102386:	e9 a5 24 00 00       	jmp    80104830 <release>
8010238b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010238f:	90                   	nop
    idestart(b);
80102390:	89 d8                	mov    %ebx,%eax
80102392:	e8 49 fd ff ff       	call   801020e0 <idestart>
80102397:	eb bd                	jmp    80102356 <iderw+0x76>
80102399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023a0:	ba e4 25 11 80       	mov    $0x801125e4,%edx
801023a5:	eb a5                	jmp    8010234c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801023a7:	83 ec 0c             	sub    $0xc,%esp
801023aa:	68 d5 78 10 80       	push   $0x801078d5
801023af:	e8 cc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023b4:	83 ec 0c             	sub    $0xc,%esp
801023b7:	68 c0 78 10 80       	push   $0x801078c0
801023bc:	e8 bf df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023c1:	83 ec 0c             	sub    $0xc,%esp
801023c4:	68 aa 78 10 80       	push   $0x801078aa
801023c9:	e8 b2 df ff ff       	call   80100380 <panic>
801023ce:	66 90                	xchg   %ax,%ax

801023d0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023d0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023d1:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801023d8:	00 c0 fe 
{
801023db:	89 e5                	mov    %esp,%ebp
801023dd:	56                   	push   %esi
801023de:	53                   	push   %ebx
  ioapic->reg = reg;
801023df:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023e6:	00 00 00 
  return ioapic->data;
801023e9:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801023ef:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023f2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023f8:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023fe:	0f b6 15 80 a7 14 80 	movzbl 0x8014a780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102405:	c1 ee 10             	shr    $0x10,%esi
80102408:	89 f0                	mov    %esi,%eax
8010240a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010240d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102410:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102413:	39 c2                	cmp    %eax,%edx
80102415:	74 16                	je     8010242d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102417:	83 ec 0c             	sub    $0xc,%esp
8010241a:	68 f4 78 10 80       	push   $0x801078f4
8010241f:	e8 7c e2 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102424:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010242a:	83 c4 10             	add    $0x10,%esp
8010242d:	83 c6 21             	add    $0x21,%esi
{
80102430:	ba 10 00 00 00       	mov    $0x10,%edx
80102435:	b8 20 00 00 00       	mov    $0x20,%eax
8010243a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102440:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102442:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102444:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  for(i = 0; i <= maxintr; i++){
8010244a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010244d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102453:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102456:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102459:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010245c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010245e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102464:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010246b:	39 f0                	cmp    %esi,%eax
8010246d:	75 d1                	jne    80102440 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010246f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102472:	5b                   	pop    %ebx
80102473:	5e                   	pop    %esi
80102474:	5d                   	pop    %ebp
80102475:	c3                   	ret    
80102476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010247d:	8d 76 00             	lea    0x0(%esi),%esi

80102480 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102480:	55                   	push   %ebp
  ioapic->reg = reg;
80102481:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
80102487:	89 e5                	mov    %esp,%ebp
80102489:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010248c:	8d 50 20             	lea    0x20(%eax),%edx
8010248f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102493:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102495:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010249b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010249e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024a4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024a6:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024ab:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024ae:	89 50 10             	mov    %edx,0x10(%eax)
}
801024b1:	5d                   	pop    %ebp
801024b2:	c3                   	ret    
801024b3:	66 90                	xchg   %ax,%ax
801024b5:	66 90                	xchg   %ax,%ax
801024b7:	66 90                	xchg   %ax,%ax
801024b9:	66 90                	xchg   %ax,%ax
801024bb:	66 90                	xchg   %ax,%ax
801024bd:	66 90                	xchg   %ax,%ax
801024bf:	90                   	nop

801024c0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	56                   	push   %esi
801024c4:	8b 75 08             	mov    0x8(%ebp),%esi
801024c7:	53                   	push   %ebx
  struct run *r;
  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024c8:	f7 c6 ff 0f 00 00    	test   $0xfff,%esi
801024ce:	0f 85 b5 00 00 00    	jne    80102589 <kfree+0xc9>
801024d4:	81 fe d0 e4 14 80    	cmp    $0x8014e4d0,%esi
801024da:	0f 82 a9 00 00 00    	jb     80102589 <kfree+0xc9>
801024e0:	8d 9e 00 00 00 80    	lea    -0x80000000(%esi),%ebx
801024e6:	81 fb ff ff ff 0d    	cmp    $0xdffffff,%ebx
801024ec:	0f 87 97 00 00 00    	ja     80102589 <kfree+0xc9>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  
  if(kmem.use_lock)
801024f2:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801024f8:	85 d2                	test   %edx,%edx
801024fa:	75 34                	jne    80102530 <kfree+0x70>
    acquire(&kmem.lock);

  r = (struct run*)v;

  if (kmem.refc[V2P(v) / PGSIZE] > 0)
801024fc:	c1 eb 0c             	shr    $0xc,%ebx
801024ff:	83 c3 10             	add    $0x10,%ebx
80102502:	8b 04 9d 40 26 11 80 	mov    -0x7feed9c0(,%ebx,4),%eax
80102509:	85 c0                	test   %eax,%eax
8010250b:	7e 0a                	jle    80102517 <kfree+0x57>
    kmem.refc[V2P(v) / PGSIZE]--;
8010250d:	83 e8 01             	sub    $0x1,%eax
80102510:	89 04 9d 40 26 11 80 	mov    %eax,-0x7feed9c0(,%ebx,4)
  if (kmem.refc[V2P(v) / PGSIZE] == 0){
80102517:	85 c0                	test   %eax,%eax
80102519:	74 45                	je     80102560 <kfree+0xa0>
    r->next = kmem.freelist;
    kmem.freelist = r;
    kmem.fpc = kmem.fpc + 1;
  }  

  if(kmem.use_lock)
8010251b:	a1 74 26 11 80       	mov    0x80112674,%eax
80102520:	85 c0                	test   %eax,%eax
80102522:	75 24                	jne    80102548 <kfree+0x88>
    release(&kmem.lock);
}
80102524:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102527:	5b                   	pop    %ebx
80102528:	5e                   	pop    %esi
80102529:	5d                   	pop    %ebp
8010252a:	c3                   	ret    
8010252b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010252f:	90                   	nop
    acquire(&kmem.lock);
80102530:	83 ec 0c             	sub    $0xc,%esp
80102533:	68 40 26 11 80       	push   $0x80112640
80102538:	e8 53 23 00 00       	call   80104890 <acquire>
8010253d:	83 c4 10             	add    $0x10,%esp
80102540:	eb ba                	jmp    801024fc <kfree+0x3c>
80102542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102548:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010254f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102552:	5b                   	pop    %ebx
80102553:	5e                   	pop    %esi
80102554:	5d                   	pop    %ebp
    release(&kmem.lock);
80102555:	e9 d6 22 00 00       	jmp    80104830 <release>
8010255a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memset(v, 1, PGSIZE);
80102560:	83 ec 04             	sub    $0x4,%esp
80102563:	68 00 10 00 00       	push   $0x1000
80102568:	6a 01                	push   $0x1
8010256a:	56                   	push   %esi
8010256b:	e8 e0 23 00 00       	call   80104950 <memset>
    r->next = kmem.freelist;
80102570:	a1 78 26 11 80       	mov    0x80112678,%eax
    kmem.fpc = kmem.fpc + 1;
80102575:	83 c4 10             	add    $0x10,%esp
    r->next = kmem.freelist;
80102578:	89 06                	mov    %eax,(%esi)
    kmem.freelist = r;
8010257a:	89 35 78 26 11 80    	mov    %esi,0x80112678
    kmem.fpc = kmem.fpc + 1;
80102580:	83 05 7c 26 11 80 01 	addl   $0x1,0x8011267c
80102587:	eb 92                	jmp    8010251b <kfree+0x5b>
    panic("kfree");
80102589:	83 ec 0c             	sub    $0xc,%esp
8010258c:	68 26 79 10 80       	push   $0x80107926
80102591:	e8 ea dd ff ff       	call   80100380 <panic>
80102596:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010259d:	8d 76 00             	lea    0x0(%esi),%esi

801025a0 <freerange>:
{
801025a0:	55                   	push   %ebp
801025a1:	89 e5                	mov    %esp,%ebp
801025a3:	57                   	push   %edi
801025a4:	56                   	push   %esi
801025a5:	53                   	push   %ebx
801025a6:	83 ec 0c             	sub    $0xc,%esp
  p = (char*)PGROUNDUP((uint)vstart);
801025a9:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025ac:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801025af:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025b5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801025bb:	8d bb 00 10 00 00    	lea    0x1000(%ebx),%edi
801025c1:	39 fe                	cmp    %edi,%esi
801025c3:	73 11                	jae    801025d6 <freerange+0x36>
801025c5:	eb 38                	jmp    801025ff <freerange+0x5f>
801025c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025ce:	66 90                	xchg   %ax,%ax
801025d0:	81 c7 00 10 00 00    	add    $0x1000,%edi
    kfree(p);
801025d6:	83 ec 0c             	sub    $0xc,%esp
    kmem.refc[(uint)p / PGSIZE] = 0;
801025d9:	89 d8                	mov    %ebx,%eax
    kfree(p);
801025db:	53                   	push   %ebx
    kmem.refc[(uint)p / PGSIZE] = 0;
801025dc:	c1 e8 0c             	shr    $0xc,%eax
801025df:	c7 04 85 80 26 11 80 	movl   $0x0,-0x7feed980(,%eax,4)
801025e6:	00 00 00 00 
    kfree(p);
801025ea:	e8 d1 fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801025ef:	89 d8                	mov    %ebx,%eax
801025f1:	83 c4 10             	add    $0x10,%esp
801025f4:	89 fb                	mov    %edi,%ebx
801025f6:	05 00 20 00 00       	add    $0x2000,%eax
801025fb:	39 c6                	cmp    %eax,%esi
801025fd:	73 d1                	jae    801025d0 <freerange+0x30>
}
801025ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102602:	5b                   	pop    %ebx
80102603:	5e                   	pop    %esi
80102604:	5f                   	pop    %edi
80102605:	5d                   	pop    %ebp
80102606:	c3                   	ret    
80102607:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010260e:	66 90                	xchg   %ax,%ax

80102610 <kinit2>:
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	57                   	push   %edi
80102614:	56                   	push   %esi
80102615:	53                   	push   %ebx
80102616:	83 ec 0c             	sub    $0xc,%esp
  p = (char*)PGROUNDUP((uint)vstart);
80102619:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010261c:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010261f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102625:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
8010262b:	8d bb 00 10 00 00    	lea    0x1000(%ebx),%edi
80102631:	39 fe                	cmp    %edi,%esi
80102633:	73 11                	jae    80102646 <kinit2+0x36>
80102635:	eb 38                	jmp    8010266f <kinit2+0x5f>
80102637:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010263e:	66 90                	xchg   %ax,%ax
80102640:	81 c7 00 10 00 00    	add    $0x1000,%edi
    kfree(p);
80102646:	83 ec 0c             	sub    $0xc,%esp
    kmem.refc[(uint)p / PGSIZE] = 0;
80102649:	89 d8                	mov    %ebx,%eax
    kfree(p);
8010264b:	53                   	push   %ebx
    kmem.refc[(uint)p / PGSIZE] = 0;
8010264c:	c1 e8 0c             	shr    $0xc,%eax
8010264f:	c7 04 85 80 26 11 80 	movl   $0x0,-0x7feed980(,%eax,4)
80102656:	00 00 00 00 
    kfree(p);
8010265a:	e8 61 fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
8010265f:	89 d8                	mov    %ebx,%eax
80102661:	83 c4 10             	add    $0x10,%esp
80102664:	89 fb                	mov    %edi,%ebx
80102666:	05 00 20 00 00       	add    $0x2000,%eax
8010266b:	39 c6                	cmp    %eax,%esi
8010266d:	73 d1                	jae    80102640 <kinit2+0x30>
  kmem.use_lock = 1;
8010266f:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
80102676:	00 00 00 
}
80102679:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010267c:	5b                   	pop    %ebx
8010267d:	5e                   	pop    %esi
8010267e:	5f                   	pop    %edi
8010267f:	5d                   	pop    %ebp
80102680:	c3                   	ret    
80102681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102688:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010268f:	90                   	nop

80102690 <kinit1>:
{
80102690:	55                   	push   %ebp
80102691:	89 e5                	mov    %esp,%ebp
80102693:	57                   	push   %edi
80102694:	56                   	push   %esi
80102695:	53                   	push   %ebx
80102696:	83 ec 14             	sub    $0x14,%esp
80102699:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
8010269c:	68 2c 79 10 80       	push   $0x8010792c
801026a1:	68 40 26 11 80       	push   $0x80112640
801026a6:	e8 15 20 00 00       	call   801046c0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801026ab:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801026ae:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801026b1:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
801026b8:	00 00 00 
  kmem.fpc = 0;
801026bb:	c7 05 7c 26 11 80 00 	movl   $0x0,0x8011267c
801026c2:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801026c5:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026cb:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801026d1:	8d bb 00 10 00 00    	lea    0x1000(%ebx),%edi
801026d7:	39 fe                	cmp    %edi,%esi
801026d9:	73 0b                	jae    801026e6 <kinit1+0x56>
801026db:	eb 32                	jmp    8010270f <kinit1+0x7f>
801026dd:	8d 76 00             	lea    0x0(%esi),%esi
801026e0:	81 c7 00 10 00 00    	add    $0x1000,%edi
    kfree(p);
801026e6:	83 ec 0c             	sub    $0xc,%esp
    kmem.refc[(uint)p / PGSIZE] = 0;
801026e9:	89 d8                	mov    %ebx,%eax
    kfree(p);
801026eb:	53                   	push   %ebx
    kmem.refc[(uint)p / PGSIZE] = 0;
801026ec:	c1 e8 0c             	shr    $0xc,%eax
801026ef:	c7 04 85 80 26 11 80 	movl   $0x0,-0x7feed980(,%eax,4)
801026f6:	00 00 00 00 
    kfree(p);
801026fa:	e8 c1 fd ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801026ff:	89 d8                	mov    %ebx,%eax
80102701:	83 c4 10             	add    $0x10,%esp
80102704:	89 fb                	mov    %edi,%ebx
80102706:	05 00 20 00 00       	add    $0x2000,%eax
8010270b:	39 c6                	cmp    %eax,%esi
8010270d:	73 d1                	jae    801026e0 <kinit1+0x50>
}
8010270f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102712:	5b                   	pop    %ebx
80102713:	5e                   	pop    %esi
80102714:	5f                   	pop    %edi
80102715:	5d                   	pop    %ebp
80102716:	c3                   	ret    
80102717:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010271e:	66 90                	xchg   %ax,%ax

80102720 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102720:	55                   	push   %ebp
80102721:	89 e5                	mov    %esp,%ebp
80102723:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102726:	8b 15 74 26 11 80    	mov    0x80112674,%edx
8010272c:	85 d2                	test   %edx,%edx
8010272e:	75 50                	jne    80102780 <kalloc+0x60>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102730:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r){
80102735:	85 c0                	test   %eax,%eax
80102737:	74 27                	je     80102760 <kalloc+0x40>
    kmem.fpc = kmem.fpc - 1;
80102739:	83 2d 7c 26 11 80 01 	subl   $0x1,0x8011267c
    kmem.freelist = r->next;
80102740:	8b 08                	mov    (%eax),%ecx
80102742:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
    kmem.refc[V2P((char*)r) / PGSIZE] = 1;
80102748:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
8010274e:	c1 e9 0c             	shr    $0xc,%ecx
80102751:	c7 04 8d 80 26 11 80 	movl   $0x1,-0x7feed980(,%ecx,4)
80102758:	01 00 00 00 
  }
  if(kmem.use_lock)
8010275c:	85 d2                	test   %edx,%edx
8010275e:	75 08                	jne    80102768 <kalloc+0x48>
    release(&kmem.lock);
  return (char*)r;
}
80102760:	c9                   	leave  
80102761:	c3                   	ret    
80102762:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102768:	83 ec 0c             	sub    $0xc,%esp
8010276b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010276e:	68 40 26 11 80       	push   $0x80112640
80102773:	e8 b8 20 00 00       	call   80104830 <release>
  return (char*)r;
80102778:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
8010277b:	83 c4 10             	add    $0x10,%esp
}
8010277e:	c9                   	leave  
8010277f:	c3                   	ret    
    acquire(&kmem.lock);
80102780:	83 ec 0c             	sub    $0xc,%esp
80102783:	68 40 26 11 80       	push   $0x80112640
80102788:	e8 03 21 00 00       	call   80104890 <acquire>
  r = kmem.freelist;
8010278d:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(kmem.use_lock)
80102792:	8b 15 74 26 11 80    	mov    0x80112674,%edx
  if(r){
80102798:	83 c4 10             	add    $0x10,%esp
8010279b:	85 c0                	test   %eax,%eax
8010279d:	75 9a                	jne    80102739 <kalloc+0x19>
8010279f:	eb bb                	jmp    8010275c <kalloc+0x3c>
801027a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027af:	90                   	nop

801027b0 <incr_refc>:

void 
incr_refc(uint pa)
{
801027b0:	55                   	push   %ebp
801027b1:	89 e5                	mov    %esp,%ebp
801027b3:	53                   	push   %ebx
801027b4:	83 ec 04             	sub    $0x4,%esp
801027b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *v = P2V(pa);
801027ba:	8d 93 00 00 00 80    	lea    -0x80000000(%ebx),%edx

  if((uint)v % PGSIZE || v < end || pa >= PHYSTOP)
801027c0:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801027c6:	0f 95 c0             	setne  %al
801027c9:	81 fa d0 e4 14 80    	cmp    $0x8014e4d0,%edx
801027cf:	0f 92 c2             	setb   %dl
801027d2:	08 d0                	or     %dl,%al
801027d4:	75 5e                	jne    80102834 <incr_refc+0x84>
801027d6:	81 fb ff ff ff 0d    	cmp    $0xdffffff,%ebx
801027dc:	77 56                	ja     80102834 <incr_refc+0x84>
    panic("incr_refc");

  if(kmem.use_lock)
801027de:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801027e4:	85 d2                	test   %edx,%edx
801027e6:	75 18                	jne    80102800 <incr_refc+0x50>
    acquire(&kmem.lock);
  
  kmem.refc[pa / PGSIZE]++;
801027e8:	c1 eb 0c             	shr    $0xc,%ebx
801027eb:	83 04 9d 80 26 11 80 	addl   $0x1,-0x7feed980(,%ebx,4)
801027f2:	01 

  if(kmem.use_lock)
    release(&kmem.lock);
}
801027f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027f6:	c9                   	leave  
801027f7:	c3                   	ret    
801027f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027ff:	90                   	nop
    acquire(&kmem.lock);
80102800:	83 ec 0c             	sub    $0xc,%esp
  kmem.refc[pa / PGSIZE]++;
80102803:	c1 eb 0c             	shr    $0xc,%ebx
    acquire(&kmem.lock);
80102806:	68 40 26 11 80       	push   $0x80112640
8010280b:	e8 80 20 00 00       	call   80104890 <acquire>
  if(kmem.use_lock)
80102810:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.refc[pa / PGSIZE]++;
80102815:	83 04 9d 80 26 11 80 	addl   $0x1,-0x7feed980(,%ebx,4)
8010281c:	01 
  if(kmem.use_lock)
8010281d:	83 c4 10             	add    $0x10,%esp
80102820:	85 c0                	test   %eax,%eax
80102822:	74 cf                	je     801027f3 <incr_refc+0x43>
    release(&kmem.lock);
80102824:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010282b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010282e:	c9                   	leave  
    release(&kmem.lock);
8010282f:	e9 fc 1f 00 00       	jmp    80104830 <release>
    panic("incr_refc");
80102834:	83 ec 0c             	sub    $0xc,%esp
80102837:	68 31 79 10 80       	push   $0x80107931
8010283c:	e8 3f db ff ff       	call   80100380 <panic>
80102841:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102848:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010284f:	90                   	nop

80102850 <decr_refc>:

void 
decr_refc(uint pa)
{
80102850:	55                   	push   %ebp
80102851:	89 e5                	mov    %esp,%ebp
80102853:	53                   	push   %ebx
80102854:	83 ec 04             	sub    $0x4,%esp
80102857:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *v = P2V(pa);
8010285a:	8d 93 00 00 00 80    	lea    -0x80000000(%ebx),%edx

  if((uint)v % PGSIZE || v < end || pa >= PHYSTOP)
80102860:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102866:	0f 95 c0             	setne  %al
80102869:	81 fa d0 e4 14 80    	cmp    $0x8014e4d0,%edx
8010286f:	0f 92 c2             	setb   %dl
80102872:	08 d0                	or     %dl,%al
80102874:	75 5e                	jne    801028d4 <decr_refc+0x84>
80102876:	81 fb ff ff ff 0d    	cmp    $0xdffffff,%ebx
8010287c:	77 56                	ja     801028d4 <decr_refc+0x84>
    panic("incr_refc");

  if(kmem.use_lock)
8010287e:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102884:	85 d2                	test   %edx,%edx
80102886:	75 18                	jne    801028a0 <decr_refc+0x50>
    acquire(&kmem.lock);
  
  kmem.refc[pa / PGSIZE]--;
80102888:	c1 eb 0c             	shr    $0xc,%ebx
8010288b:	83 2c 9d 80 26 11 80 	subl   $0x1,-0x7feed980(,%ebx,4)
80102892:	01 

  if(kmem.use_lock)
    release(&kmem.lock);
}
80102893:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102896:	c9                   	leave  
80102897:	c3                   	ret    
80102898:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010289f:	90                   	nop
    acquire(&kmem.lock);
801028a0:	83 ec 0c             	sub    $0xc,%esp
  kmem.refc[pa / PGSIZE]--;
801028a3:	c1 eb 0c             	shr    $0xc,%ebx
    acquire(&kmem.lock);
801028a6:	68 40 26 11 80       	push   $0x80112640
801028ab:	e8 e0 1f 00 00       	call   80104890 <acquire>
  if(kmem.use_lock)
801028b0:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.refc[pa / PGSIZE]--;
801028b5:	83 2c 9d 80 26 11 80 	subl   $0x1,-0x7feed980(,%ebx,4)
801028bc:	01 
  if(kmem.use_lock)
801028bd:	83 c4 10             	add    $0x10,%esp
801028c0:	85 c0                	test   %eax,%eax
801028c2:	74 cf                	je     80102893 <decr_refc+0x43>
    release(&kmem.lock);
801028c4:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
801028cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028ce:	c9                   	leave  
    release(&kmem.lock);
801028cf:	e9 5c 1f 00 00       	jmp    80104830 <release>
    panic("incr_refc");
801028d4:	83 ec 0c             	sub    $0xc,%esp
801028d7:	68 31 79 10 80       	push   $0x80107931
801028dc:	e8 9f da ff ff       	call   80100380 <panic>
801028e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028ef:	90                   	nop

801028f0 <get_refc>:

int 
get_refc(uint pa)
{
801028f0:	55                   	push   %ebp
801028f1:	89 e5                	mov    %esp,%ebp
801028f3:	53                   	push   %ebx
801028f4:	83 ec 14             	sub    $0x14,%esp
801028f7:	8b 45 08             	mov    0x8(%ebp),%eax
  int refc;
  char *v = P2V(pa);
801028fa:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx

  if((uint)v % PGSIZE || v < end || pa >= PHYSTOP)
80102900:	a9 ff 0f 00 00       	test   $0xfff,%eax
80102905:	0f 95 c2             	setne  %dl
80102908:	81 f9 d0 e4 14 80    	cmp    $0x8014e4d0,%ecx
8010290e:	0f 92 c1             	setb   %cl
80102911:	08 ca                	or     %cl,%dl
80102913:	75 67                	jne    8010297c <get_refc+0x8c>
80102915:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
8010291a:	77 60                	ja     8010297c <get_refc+0x8c>
    panic("get_refc");

  if(kmem.use_lock)
8010291c:	8b 0d 74 26 11 80    	mov    0x80112674,%ecx
    acquire(&kmem.lock);
  
  refc = kmem.refc[pa / PGSIZE];
80102922:	c1 e8 0c             	shr    $0xc,%eax
80102925:	89 c3                	mov    %eax,%ebx
  if(kmem.use_lock)
80102927:	85 c9                	test   %ecx,%ecx
80102929:	75 15                	jne    80102940 <get_refc+0x50>
  refc = kmem.refc[pa / PGSIZE];
8010292b:	8b 04 85 80 26 11 80 	mov    -0x7feed980(,%eax,4),%eax

  if(kmem.use_lock)
    release(&kmem.lock);
  
  return refc;
}
80102932:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102935:	c9                   	leave  
80102936:	c3                   	ret    
80102937:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010293e:	66 90                	xchg   %ax,%ax
    acquire(&kmem.lock);
80102940:	83 ec 0c             	sub    $0xc,%esp
80102943:	68 40 26 11 80       	push   $0x80112640
80102948:	e8 43 1f 00 00       	call   80104890 <acquire>
  if(kmem.use_lock)
8010294d:	8b 15 74 26 11 80    	mov    0x80112674,%edx
  refc = kmem.refc[pa / PGSIZE];
80102953:	8b 04 9d 80 26 11 80 	mov    -0x7feed980(,%ebx,4),%eax
  if(kmem.use_lock)
8010295a:	83 c4 10             	add    $0x10,%esp
8010295d:	85 d2                	test   %edx,%edx
8010295f:	74 d1                	je     80102932 <get_refc+0x42>
    release(&kmem.lock);
80102961:	83 ec 0c             	sub    $0xc,%esp
80102964:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102967:	68 40 26 11 80       	push   $0x80112640
8010296c:	e8 bf 1e 00 00       	call   80104830 <release>
  return refc;
80102971:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102974:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    release(&kmem.lock);
80102977:	83 c4 10             	add    $0x10,%esp
}
8010297a:	c9                   	leave  
8010297b:	c3                   	ret    
    panic("get_refc");
8010297c:	83 ec 0c             	sub    $0xc,%esp
8010297f:	68 3b 79 10 80       	push   $0x8010793b
80102984:	e8 f7 d9 ff ff       	call   80100380 <panic>
80102989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102990 <sys_countfp>:

int 
sys_countfp(void)
{ 
  int fpc;
  if(kmem.use_lock)
80102990:	8b 0d 74 26 11 80    	mov    0x80112674,%ecx
    acquire(&kmem.lock);
  fpc = kmem.fpc;
80102996:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  if(kmem.use_lock)
8010299b:	85 c9                	test   %ecx,%ecx
8010299d:	75 01                	jne    801029a0 <sys_countfp+0x10>
  if (kmem.use_lock)
    release(&kmem.lock);
  return fpc;
}
8010299f:	c3                   	ret    
{ 
801029a0:	55                   	push   %ebp
801029a1:	89 e5                	mov    %esp,%ebp
801029a3:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801029a6:	68 40 26 11 80       	push   $0x80112640
801029ab:	e8 e0 1e 00 00       	call   80104890 <acquire>
  if (kmem.use_lock)
801029b0:	8b 15 74 26 11 80    	mov    0x80112674,%edx
  fpc = kmem.fpc;
801029b6:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  if (kmem.use_lock)
801029bb:	83 c4 10             	add    $0x10,%esp
801029be:	85 d2                	test   %edx,%edx
801029c0:	74 16                	je     801029d8 <sys_countfp+0x48>
    release(&kmem.lock);
801029c2:	83 ec 0c             	sub    $0xc,%esp
801029c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801029c8:	68 40 26 11 80       	push   $0x80112640
801029cd:	e8 5e 1e 00 00       	call   80104830 <release>
801029d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029d5:	83 c4 10             	add    $0x10,%esp
}
801029d8:	c9                   	leave  
801029d9:	c3                   	ret    
801029da:	66 90                	xchg   %ax,%ax
801029dc:	66 90                	xchg   %ax,%ax
801029de:	66 90                	xchg   %ax,%ax

801029e0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029e0:	ba 64 00 00 00       	mov    $0x64,%edx
801029e5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801029e6:	a8 01                	test   $0x1,%al
801029e8:	0f 84 c2 00 00 00    	je     80102ab0 <kbdgetc+0xd0>
{
801029ee:	55                   	push   %ebp
801029ef:	ba 60 00 00 00       	mov    $0x60,%edx
801029f4:	89 e5                	mov    %esp,%ebp
801029f6:	53                   	push   %ebx
801029f7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801029f8:	8b 1d 80 a6 14 80    	mov    0x8014a680,%ebx
  data = inb(KBDATAP);
801029fe:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102a01:	3c e0                	cmp    $0xe0,%al
80102a03:	74 5b                	je     80102a60 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102a05:	89 da                	mov    %ebx,%edx
80102a07:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
80102a0a:	84 c0                	test   %al,%al
80102a0c:	78 62                	js     80102a70 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102a0e:	85 d2                	test   %edx,%edx
80102a10:	74 09                	je     80102a1b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102a12:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102a15:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102a18:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
80102a1b:	0f b6 91 80 7a 10 80 	movzbl -0x7fef8580(%ecx),%edx
  shift ^= togglecode[data];
80102a22:	0f b6 81 80 79 10 80 	movzbl -0x7fef8680(%ecx),%eax
  shift |= shiftcode[data];
80102a29:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80102a2b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80102a2d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
80102a2f:	89 15 80 a6 14 80    	mov    %edx,0x8014a680
  c = charcode[shift & (CTL | SHIFT)][data];
80102a35:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102a38:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80102a3b:	8b 04 85 60 79 10 80 	mov    -0x7fef86a0(,%eax,4),%eax
80102a42:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102a46:	74 0b                	je     80102a53 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102a48:	8d 50 9f             	lea    -0x61(%eax),%edx
80102a4b:	83 fa 19             	cmp    $0x19,%edx
80102a4e:	77 48                	ja     80102a98 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102a50:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102a53:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a56:	c9                   	leave  
80102a57:	c3                   	ret    
80102a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a5f:	90                   	nop
    shift |= E0ESC;
80102a60:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102a63:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102a65:	89 1d 80 a6 14 80    	mov    %ebx,0x8014a680
}
80102a6b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a6e:	c9                   	leave  
80102a6f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102a70:	83 e0 7f             	and    $0x7f,%eax
80102a73:	85 d2                	test   %edx,%edx
80102a75:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102a78:	0f b6 81 80 7a 10 80 	movzbl -0x7fef8580(%ecx),%eax
80102a7f:	83 c8 40             	or     $0x40,%eax
80102a82:	0f b6 c0             	movzbl %al,%eax
80102a85:	f7 d0                	not    %eax
80102a87:	21 d8                	and    %ebx,%eax
}
80102a89:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
80102a8c:	a3 80 a6 14 80       	mov    %eax,0x8014a680
    return 0;
80102a91:	31 c0                	xor    %eax,%eax
}
80102a93:	c9                   	leave  
80102a94:	c3                   	ret    
80102a95:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102a98:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102a9b:	8d 50 20             	lea    0x20(%eax),%edx
}
80102a9e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102aa1:	c9                   	leave  
      c += 'a' - 'A';
80102aa2:	83 f9 1a             	cmp    $0x1a,%ecx
80102aa5:	0f 42 c2             	cmovb  %edx,%eax
}
80102aa8:	c3                   	ret    
80102aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102ab0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102ab5:	c3                   	ret    
80102ab6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102abd:	8d 76 00             	lea    0x0(%esi),%esi

80102ac0 <kbdintr>:

void
kbdintr(void)
{
80102ac0:	55                   	push   %ebp
80102ac1:	89 e5                	mov    %esp,%ebp
80102ac3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102ac6:	68 e0 29 10 80       	push   $0x801029e0
80102acb:	e8 b0 dd ff ff       	call   80100880 <consoleintr>
}
80102ad0:	83 c4 10             	add    $0x10,%esp
80102ad3:	c9                   	leave  
80102ad4:	c3                   	ret    
80102ad5:	66 90                	xchg   %ax,%ax
80102ad7:	66 90                	xchg   %ax,%ax
80102ad9:	66 90                	xchg   %ax,%ax
80102adb:	66 90                	xchg   %ax,%ax
80102add:	66 90                	xchg   %ax,%ax
80102adf:	90                   	nop

80102ae0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102ae0:	a1 84 a6 14 80       	mov    0x8014a684,%eax
80102ae5:	85 c0                	test   %eax,%eax
80102ae7:	0f 84 cb 00 00 00    	je     80102bb8 <lapicinit+0xd8>
  lapic[index] = value;
80102aed:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102af4:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102af7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102afa:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102b01:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b04:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b07:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102b0e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102b11:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b14:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102b1b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102b1e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b21:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102b28:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102b2b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b2e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102b35:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102b38:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102b3b:	8b 50 30             	mov    0x30(%eax),%edx
80102b3e:	c1 ea 10             	shr    $0x10,%edx
80102b41:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102b47:	75 77                	jne    80102bc0 <lapicinit+0xe0>
  lapic[index] = value;
80102b49:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102b50:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b53:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b56:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102b5d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b60:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b63:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102b6a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b6d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b70:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102b77:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b7a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b7d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102b84:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b87:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b8a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102b91:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102b94:	8b 50 20             	mov    0x20(%eax),%edx
80102b97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b9e:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102ba0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102ba6:	80 e6 10             	and    $0x10,%dh
80102ba9:	75 f5                	jne    80102ba0 <lapicinit+0xc0>
  lapic[index] = value;
80102bab:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102bb2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bb5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102bb8:	c3                   	ret    
80102bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102bc0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102bc7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102bca:	8b 50 20             	mov    0x20(%eax),%edx
}
80102bcd:	e9 77 ff ff ff       	jmp    80102b49 <lapicinit+0x69>
80102bd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102be0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102be0:	a1 84 a6 14 80       	mov    0x8014a684,%eax
80102be5:	85 c0                	test   %eax,%eax
80102be7:	74 07                	je     80102bf0 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102be9:	8b 40 20             	mov    0x20(%eax),%eax
80102bec:	c1 e8 18             	shr    $0x18,%eax
80102bef:	c3                   	ret    
    return 0;
80102bf0:	31 c0                	xor    %eax,%eax
}
80102bf2:	c3                   	ret    
80102bf3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102c00 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102c00:	a1 84 a6 14 80       	mov    0x8014a684,%eax
80102c05:	85 c0                	test   %eax,%eax
80102c07:	74 0d                	je     80102c16 <lapiceoi+0x16>
  lapic[index] = value;
80102c09:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102c10:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c13:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102c16:	c3                   	ret    
80102c17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c1e:	66 90                	xchg   %ax,%ax

80102c20 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102c20:	c3                   	ret    
80102c21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c2f:	90                   	nop

80102c30 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102c30:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c31:	b8 0f 00 00 00       	mov    $0xf,%eax
80102c36:	ba 70 00 00 00       	mov    $0x70,%edx
80102c3b:	89 e5                	mov    %esp,%ebp
80102c3d:	53                   	push   %ebx
80102c3e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102c41:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102c44:	ee                   	out    %al,(%dx)
80102c45:	b8 0a 00 00 00       	mov    $0xa,%eax
80102c4a:	ba 71 00 00 00       	mov    $0x71,%edx
80102c4f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102c50:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102c52:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102c55:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102c5b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102c5d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102c60:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102c62:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102c65:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102c68:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102c6e:	a1 84 a6 14 80       	mov    0x8014a684,%eax
80102c73:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c79:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102c7c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102c83:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c86:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102c89:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102c90:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c93:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102c96:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c9c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102c9f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ca5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ca8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102cae:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cb1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102cb7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102cba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cbd:	c9                   	leave  
80102cbe:	c3                   	ret    
80102cbf:	90                   	nop

80102cc0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102cc0:	55                   	push   %ebp
80102cc1:	b8 0b 00 00 00       	mov    $0xb,%eax
80102cc6:	ba 70 00 00 00       	mov    $0x70,%edx
80102ccb:	89 e5                	mov    %esp,%ebp
80102ccd:	57                   	push   %edi
80102cce:	56                   	push   %esi
80102ccf:	53                   	push   %ebx
80102cd0:	83 ec 4c             	sub    $0x4c,%esp
80102cd3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cd4:	ba 71 00 00 00       	mov    $0x71,%edx
80102cd9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102cda:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cdd:	bb 70 00 00 00       	mov    $0x70,%ebx
80102ce2:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102ce5:	8d 76 00             	lea    0x0(%esi),%esi
80102ce8:	31 c0                	xor    %eax,%eax
80102cea:	89 da                	mov    %ebx,%edx
80102cec:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ced:	b9 71 00 00 00       	mov    $0x71,%ecx
80102cf2:	89 ca                	mov    %ecx,%edx
80102cf4:	ec                   	in     (%dx),%al
80102cf5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cf8:	89 da                	mov    %ebx,%edx
80102cfa:	b8 02 00 00 00       	mov    $0x2,%eax
80102cff:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d00:	89 ca                	mov    %ecx,%edx
80102d02:	ec                   	in     (%dx),%al
80102d03:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d06:	89 da                	mov    %ebx,%edx
80102d08:	b8 04 00 00 00       	mov    $0x4,%eax
80102d0d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d0e:	89 ca                	mov    %ecx,%edx
80102d10:	ec                   	in     (%dx),%al
80102d11:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d14:	89 da                	mov    %ebx,%edx
80102d16:	b8 07 00 00 00       	mov    $0x7,%eax
80102d1b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d1c:	89 ca                	mov    %ecx,%edx
80102d1e:	ec                   	in     (%dx),%al
80102d1f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d22:	89 da                	mov    %ebx,%edx
80102d24:	b8 08 00 00 00       	mov    $0x8,%eax
80102d29:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d2a:	89 ca                	mov    %ecx,%edx
80102d2c:	ec                   	in     (%dx),%al
80102d2d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d2f:	89 da                	mov    %ebx,%edx
80102d31:	b8 09 00 00 00       	mov    $0x9,%eax
80102d36:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d37:	89 ca                	mov    %ecx,%edx
80102d39:	ec                   	in     (%dx),%al
80102d3a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d3c:	89 da                	mov    %ebx,%edx
80102d3e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102d43:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d44:	89 ca                	mov    %ecx,%edx
80102d46:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102d47:	84 c0                	test   %al,%al
80102d49:	78 9d                	js     80102ce8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102d4b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102d4f:	89 fa                	mov    %edi,%edx
80102d51:	0f b6 fa             	movzbl %dl,%edi
80102d54:	89 f2                	mov    %esi,%edx
80102d56:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102d59:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102d5d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d60:	89 da                	mov    %ebx,%edx
80102d62:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102d65:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102d68:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102d6c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102d6f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102d72:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102d76:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102d79:	31 c0                	xor    %eax,%eax
80102d7b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d7c:	89 ca                	mov    %ecx,%edx
80102d7e:	ec                   	in     (%dx),%al
80102d7f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d82:	89 da                	mov    %ebx,%edx
80102d84:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102d87:	b8 02 00 00 00       	mov    $0x2,%eax
80102d8c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d8d:	89 ca                	mov    %ecx,%edx
80102d8f:	ec                   	in     (%dx),%al
80102d90:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d93:	89 da                	mov    %ebx,%edx
80102d95:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102d98:	b8 04 00 00 00       	mov    $0x4,%eax
80102d9d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d9e:	89 ca                	mov    %ecx,%edx
80102da0:	ec                   	in     (%dx),%al
80102da1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102da4:	89 da                	mov    %ebx,%edx
80102da6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102da9:	b8 07 00 00 00       	mov    $0x7,%eax
80102dae:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102daf:	89 ca                	mov    %ecx,%edx
80102db1:	ec                   	in     (%dx),%al
80102db2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102db5:	89 da                	mov    %ebx,%edx
80102db7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102dba:	b8 08 00 00 00       	mov    $0x8,%eax
80102dbf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dc0:	89 ca                	mov    %ecx,%edx
80102dc2:	ec                   	in     (%dx),%al
80102dc3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dc6:	89 da                	mov    %ebx,%edx
80102dc8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102dcb:	b8 09 00 00 00       	mov    $0x9,%eax
80102dd0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dd1:	89 ca                	mov    %ecx,%edx
80102dd3:	ec                   	in     (%dx),%al
80102dd4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102dd7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102dda:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ddd:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102de0:	6a 18                	push   $0x18
80102de2:	50                   	push   %eax
80102de3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102de6:	50                   	push   %eax
80102de7:	e8 b4 1b 00 00       	call   801049a0 <memcmp>
80102dec:	83 c4 10             	add    $0x10,%esp
80102def:	85 c0                	test   %eax,%eax
80102df1:	0f 85 f1 fe ff ff    	jne    80102ce8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102df7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102dfb:	75 78                	jne    80102e75 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102dfd:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102e00:	89 c2                	mov    %eax,%edx
80102e02:	83 e0 0f             	and    $0xf,%eax
80102e05:	c1 ea 04             	shr    $0x4,%edx
80102e08:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e0b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e0e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102e11:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102e14:	89 c2                	mov    %eax,%edx
80102e16:	83 e0 0f             	and    $0xf,%eax
80102e19:	c1 ea 04             	shr    $0x4,%edx
80102e1c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e1f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e22:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102e25:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102e28:	89 c2                	mov    %eax,%edx
80102e2a:	83 e0 0f             	and    $0xf,%eax
80102e2d:	c1 ea 04             	shr    $0x4,%edx
80102e30:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e33:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e36:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102e39:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102e3c:	89 c2                	mov    %eax,%edx
80102e3e:	83 e0 0f             	and    $0xf,%eax
80102e41:	c1 ea 04             	shr    $0x4,%edx
80102e44:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e47:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e4a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102e4d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102e50:	89 c2                	mov    %eax,%edx
80102e52:	83 e0 0f             	and    $0xf,%eax
80102e55:	c1 ea 04             	shr    $0x4,%edx
80102e58:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e5b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e5e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102e61:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102e64:	89 c2                	mov    %eax,%edx
80102e66:	83 e0 0f             	and    $0xf,%eax
80102e69:	c1 ea 04             	shr    $0x4,%edx
80102e6c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e6f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e72:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102e75:	8b 75 08             	mov    0x8(%ebp),%esi
80102e78:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102e7b:	89 06                	mov    %eax,(%esi)
80102e7d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102e80:	89 46 04             	mov    %eax,0x4(%esi)
80102e83:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102e86:	89 46 08             	mov    %eax,0x8(%esi)
80102e89:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102e8c:	89 46 0c             	mov    %eax,0xc(%esi)
80102e8f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102e92:	89 46 10             	mov    %eax,0x10(%esi)
80102e95:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102e98:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102e9b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102ea2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ea5:	5b                   	pop    %ebx
80102ea6:	5e                   	pop    %esi
80102ea7:	5f                   	pop    %edi
80102ea8:	5d                   	pop    %ebp
80102ea9:	c3                   	ret    
80102eaa:	66 90                	xchg   %ax,%ax
80102eac:	66 90                	xchg   %ax,%ax
80102eae:	66 90                	xchg   %ax,%ax

80102eb0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102eb0:	8b 0d e8 a6 14 80    	mov    0x8014a6e8,%ecx
80102eb6:	85 c9                	test   %ecx,%ecx
80102eb8:	0f 8e 8a 00 00 00    	jle    80102f48 <install_trans+0x98>
{
80102ebe:	55                   	push   %ebp
80102ebf:	89 e5                	mov    %esp,%ebp
80102ec1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102ec2:	31 ff                	xor    %edi,%edi
{
80102ec4:	56                   	push   %esi
80102ec5:	53                   	push   %ebx
80102ec6:	83 ec 0c             	sub    $0xc,%esp
80102ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102ed0:	a1 d4 a6 14 80       	mov    0x8014a6d4,%eax
80102ed5:	83 ec 08             	sub    $0x8,%esp
80102ed8:	01 f8                	add    %edi,%eax
80102eda:	83 c0 01             	add    $0x1,%eax
80102edd:	50                   	push   %eax
80102ede:	ff 35 e4 a6 14 80    	push   0x8014a6e4
80102ee4:	e8 e7 d1 ff ff       	call   801000d0 <bread>
80102ee9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102eeb:	58                   	pop    %eax
80102eec:	5a                   	pop    %edx
80102eed:	ff 34 bd ec a6 14 80 	push   -0x7feb5914(,%edi,4)
80102ef4:	ff 35 e4 a6 14 80    	push   0x8014a6e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102efa:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102efd:	e8 ce d1 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102f02:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102f05:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102f07:	8d 46 5c             	lea    0x5c(%esi),%eax
80102f0a:	68 00 02 00 00       	push   $0x200
80102f0f:	50                   	push   %eax
80102f10:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102f13:	50                   	push   %eax
80102f14:	e8 d7 1a 00 00       	call   801049f0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102f19:	89 1c 24             	mov    %ebx,(%esp)
80102f1c:	e8 8f d2 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102f21:	89 34 24             	mov    %esi,(%esp)
80102f24:	e8 c7 d2 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102f29:	89 1c 24             	mov    %ebx,(%esp)
80102f2c:	e8 bf d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102f31:	83 c4 10             	add    $0x10,%esp
80102f34:	39 3d e8 a6 14 80    	cmp    %edi,0x8014a6e8
80102f3a:	7f 94                	jg     80102ed0 <install_trans+0x20>
  }
}
80102f3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f3f:	5b                   	pop    %ebx
80102f40:	5e                   	pop    %esi
80102f41:	5f                   	pop    %edi
80102f42:	5d                   	pop    %ebp
80102f43:	c3                   	ret    
80102f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f48:	c3                   	ret    
80102f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102f50 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102f50:	55                   	push   %ebp
80102f51:	89 e5                	mov    %esp,%ebp
80102f53:	53                   	push   %ebx
80102f54:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102f57:	ff 35 d4 a6 14 80    	push   0x8014a6d4
80102f5d:	ff 35 e4 a6 14 80    	push   0x8014a6e4
80102f63:	e8 68 d1 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102f68:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102f6b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102f6d:	a1 e8 a6 14 80       	mov    0x8014a6e8,%eax
80102f72:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102f75:	85 c0                	test   %eax,%eax
80102f77:	7e 19                	jle    80102f92 <write_head+0x42>
80102f79:	31 d2                	xor    %edx,%edx
80102f7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f7f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102f80:	8b 0c 95 ec a6 14 80 	mov    -0x7feb5914(,%edx,4),%ecx
80102f87:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102f8b:	83 c2 01             	add    $0x1,%edx
80102f8e:	39 d0                	cmp    %edx,%eax
80102f90:	75 ee                	jne    80102f80 <write_head+0x30>
  }
  bwrite(buf);
80102f92:	83 ec 0c             	sub    $0xc,%esp
80102f95:	53                   	push   %ebx
80102f96:	e8 15 d2 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102f9b:	89 1c 24             	mov    %ebx,(%esp)
80102f9e:	e8 4d d2 ff ff       	call   801001f0 <brelse>
}
80102fa3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102fa6:	83 c4 10             	add    $0x10,%esp
80102fa9:	c9                   	leave  
80102faa:	c3                   	ret    
80102fab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102faf:	90                   	nop

80102fb0 <initlog>:
{
80102fb0:	55                   	push   %ebp
80102fb1:	89 e5                	mov    %esp,%ebp
80102fb3:	53                   	push   %ebx
80102fb4:	83 ec 2c             	sub    $0x2c,%esp
80102fb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102fba:	68 80 7b 10 80       	push   $0x80107b80
80102fbf:	68 a0 a6 14 80       	push   $0x8014a6a0
80102fc4:	e8 f7 16 00 00       	call   801046c0 <initlock>
  readsb(dev, &sb);
80102fc9:	58                   	pop    %eax
80102fca:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102fcd:	5a                   	pop    %edx
80102fce:	50                   	push   %eax
80102fcf:	53                   	push   %ebx
80102fd0:	e8 4b e5 ff ff       	call   80101520 <readsb>
  log.start = sb.logstart;
80102fd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102fd8:	59                   	pop    %ecx
  log.dev = dev;
80102fd9:	89 1d e4 a6 14 80    	mov    %ebx,0x8014a6e4
  log.size = sb.nlog;
80102fdf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102fe2:	a3 d4 a6 14 80       	mov    %eax,0x8014a6d4
  log.size = sb.nlog;
80102fe7:	89 15 d8 a6 14 80    	mov    %edx,0x8014a6d8
  struct buf *buf = bread(log.dev, log.start);
80102fed:	5a                   	pop    %edx
80102fee:	50                   	push   %eax
80102fef:	53                   	push   %ebx
80102ff0:	e8 db d0 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102ff5:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102ff8:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102ffb:	89 1d e8 a6 14 80    	mov    %ebx,0x8014a6e8
  for (i = 0; i < log.lh.n; i++) {
80103001:	85 db                	test   %ebx,%ebx
80103003:	7e 1d                	jle    80103022 <initlog+0x72>
80103005:	31 d2                	xor    %edx,%edx
80103007:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010300e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80103010:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80103014:	89 0c 95 ec a6 14 80 	mov    %ecx,-0x7feb5914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010301b:	83 c2 01             	add    $0x1,%edx
8010301e:	39 d3                	cmp    %edx,%ebx
80103020:	75 ee                	jne    80103010 <initlog+0x60>
  brelse(buf);
80103022:	83 ec 0c             	sub    $0xc,%esp
80103025:	50                   	push   %eax
80103026:	e8 c5 d1 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010302b:	e8 80 fe ff ff       	call   80102eb0 <install_trans>
  log.lh.n = 0;
80103030:	c7 05 e8 a6 14 80 00 	movl   $0x0,0x8014a6e8
80103037:	00 00 00 
  write_head(); // clear the log
8010303a:	e8 11 ff ff ff       	call   80102f50 <write_head>
}
8010303f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103042:	83 c4 10             	add    $0x10,%esp
80103045:	c9                   	leave  
80103046:	c3                   	ret    
80103047:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010304e:	66 90                	xchg   %ax,%ax

80103050 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103050:	55                   	push   %ebp
80103051:	89 e5                	mov    %esp,%ebp
80103053:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80103056:	68 a0 a6 14 80       	push   $0x8014a6a0
8010305b:	e8 30 18 00 00       	call   80104890 <acquire>
80103060:	83 c4 10             	add    $0x10,%esp
80103063:	eb 18                	jmp    8010307d <begin_op+0x2d>
80103065:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103068:	83 ec 08             	sub    $0x8,%esp
8010306b:	68 a0 a6 14 80       	push   $0x8014a6a0
80103070:	68 a0 a6 14 80       	push   $0x8014a6a0
80103075:	e8 b6 12 00 00       	call   80104330 <sleep>
8010307a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010307d:	a1 e0 a6 14 80       	mov    0x8014a6e0,%eax
80103082:	85 c0                	test   %eax,%eax
80103084:	75 e2                	jne    80103068 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103086:	a1 dc a6 14 80       	mov    0x8014a6dc,%eax
8010308b:	8b 15 e8 a6 14 80    	mov    0x8014a6e8,%edx
80103091:	83 c0 01             	add    $0x1,%eax
80103094:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80103097:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
8010309a:	83 fa 1e             	cmp    $0x1e,%edx
8010309d:	7f c9                	jg     80103068 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
8010309f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
801030a2:	a3 dc a6 14 80       	mov    %eax,0x8014a6dc
      release(&log.lock);
801030a7:	68 a0 a6 14 80       	push   $0x8014a6a0
801030ac:	e8 7f 17 00 00       	call   80104830 <release>
      break;
    }
  }
}
801030b1:	83 c4 10             	add    $0x10,%esp
801030b4:	c9                   	leave  
801030b5:	c3                   	ret    
801030b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030bd:	8d 76 00             	lea    0x0(%esi),%esi

801030c0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801030c0:	55                   	push   %ebp
801030c1:	89 e5                	mov    %esp,%ebp
801030c3:	57                   	push   %edi
801030c4:	56                   	push   %esi
801030c5:	53                   	push   %ebx
801030c6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
801030c9:	68 a0 a6 14 80       	push   $0x8014a6a0
801030ce:	e8 bd 17 00 00       	call   80104890 <acquire>
  log.outstanding -= 1;
801030d3:	a1 dc a6 14 80       	mov    0x8014a6dc,%eax
  if(log.committing)
801030d8:	8b 35 e0 a6 14 80    	mov    0x8014a6e0,%esi
801030de:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801030e1:	8d 58 ff             	lea    -0x1(%eax),%ebx
801030e4:	89 1d dc a6 14 80    	mov    %ebx,0x8014a6dc
  if(log.committing)
801030ea:	85 f6                	test   %esi,%esi
801030ec:	0f 85 22 01 00 00    	jne    80103214 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
801030f2:	85 db                	test   %ebx,%ebx
801030f4:	0f 85 f6 00 00 00    	jne    801031f0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
801030fa:	c7 05 e0 a6 14 80 01 	movl   $0x1,0x8014a6e0
80103101:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103104:	83 ec 0c             	sub    $0xc,%esp
80103107:	68 a0 a6 14 80       	push   $0x8014a6a0
8010310c:	e8 1f 17 00 00       	call   80104830 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103111:	8b 0d e8 a6 14 80    	mov    0x8014a6e8,%ecx
80103117:	83 c4 10             	add    $0x10,%esp
8010311a:	85 c9                	test   %ecx,%ecx
8010311c:	7f 42                	jg     80103160 <end_op+0xa0>
    acquire(&log.lock);
8010311e:	83 ec 0c             	sub    $0xc,%esp
80103121:	68 a0 a6 14 80       	push   $0x8014a6a0
80103126:	e8 65 17 00 00       	call   80104890 <acquire>
    wakeup(&log);
8010312b:	c7 04 24 a0 a6 14 80 	movl   $0x8014a6a0,(%esp)
    log.committing = 0;
80103132:	c7 05 e0 a6 14 80 00 	movl   $0x0,0x8014a6e0
80103139:	00 00 00 
    wakeup(&log);
8010313c:	e8 af 12 00 00       	call   801043f0 <wakeup>
    release(&log.lock);
80103141:	c7 04 24 a0 a6 14 80 	movl   $0x8014a6a0,(%esp)
80103148:	e8 e3 16 00 00       	call   80104830 <release>
8010314d:	83 c4 10             	add    $0x10,%esp
}
80103150:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103153:	5b                   	pop    %ebx
80103154:	5e                   	pop    %esi
80103155:	5f                   	pop    %edi
80103156:	5d                   	pop    %ebp
80103157:	c3                   	ret    
80103158:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010315f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103160:	a1 d4 a6 14 80       	mov    0x8014a6d4,%eax
80103165:	83 ec 08             	sub    $0x8,%esp
80103168:	01 d8                	add    %ebx,%eax
8010316a:	83 c0 01             	add    $0x1,%eax
8010316d:	50                   	push   %eax
8010316e:	ff 35 e4 a6 14 80    	push   0x8014a6e4
80103174:	e8 57 cf ff ff       	call   801000d0 <bread>
80103179:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010317b:	58                   	pop    %eax
8010317c:	5a                   	pop    %edx
8010317d:	ff 34 9d ec a6 14 80 	push   -0x7feb5914(,%ebx,4)
80103184:	ff 35 e4 a6 14 80    	push   0x8014a6e4
  for (tail = 0; tail < log.lh.n; tail++) {
8010318a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010318d:	e8 3e cf ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103192:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103195:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103197:	8d 40 5c             	lea    0x5c(%eax),%eax
8010319a:	68 00 02 00 00       	push   $0x200
8010319f:	50                   	push   %eax
801031a0:	8d 46 5c             	lea    0x5c(%esi),%eax
801031a3:	50                   	push   %eax
801031a4:	e8 47 18 00 00       	call   801049f0 <memmove>
    bwrite(to);  // write the log
801031a9:	89 34 24             	mov    %esi,(%esp)
801031ac:	e8 ff cf ff ff       	call   801001b0 <bwrite>
    brelse(from);
801031b1:	89 3c 24             	mov    %edi,(%esp)
801031b4:	e8 37 d0 ff ff       	call   801001f0 <brelse>
    brelse(to);
801031b9:	89 34 24             	mov    %esi,(%esp)
801031bc:	e8 2f d0 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801031c1:	83 c4 10             	add    $0x10,%esp
801031c4:	3b 1d e8 a6 14 80    	cmp    0x8014a6e8,%ebx
801031ca:	7c 94                	jl     80103160 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801031cc:	e8 7f fd ff ff       	call   80102f50 <write_head>
    install_trans(); // Now install writes to home locations
801031d1:	e8 da fc ff ff       	call   80102eb0 <install_trans>
    log.lh.n = 0;
801031d6:	c7 05 e8 a6 14 80 00 	movl   $0x0,0x8014a6e8
801031dd:	00 00 00 
    write_head();    // Erase the transaction from the log
801031e0:	e8 6b fd ff ff       	call   80102f50 <write_head>
801031e5:	e9 34 ff ff ff       	jmp    8010311e <end_op+0x5e>
801031ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
801031f0:	83 ec 0c             	sub    $0xc,%esp
801031f3:	68 a0 a6 14 80       	push   $0x8014a6a0
801031f8:	e8 f3 11 00 00       	call   801043f0 <wakeup>
  release(&log.lock);
801031fd:	c7 04 24 a0 a6 14 80 	movl   $0x8014a6a0,(%esp)
80103204:	e8 27 16 00 00       	call   80104830 <release>
80103209:	83 c4 10             	add    $0x10,%esp
}
8010320c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010320f:	5b                   	pop    %ebx
80103210:	5e                   	pop    %esi
80103211:	5f                   	pop    %edi
80103212:	5d                   	pop    %ebp
80103213:	c3                   	ret    
    panic("log.committing");
80103214:	83 ec 0c             	sub    $0xc,%esp
80103217:	68 84 7b 10 80       	push   $0x80107b84
8010321c:	e8 5f d1 ff ff       	call   80100380 <panic>
80103221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103228:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010322f:	90                   	nop

80103230 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103230:	55                   	push   %ebp
80103231:	89 e5                	mov    %esp,%ebp
80103233:	53                   	push   %ebx
80103234:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103237:	8b 15 e8 a6 14 80    	mov    0x8014a6e8,%edx
{
8010323d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103240:	83 fa 1d             	cmp    $0x1d,%edx
80103243:	0f 8f 85 00 00 00    	jg     801032ce <log_write+0x9e>
80103249:	a1 d8 a6 14 80       	mov    0x8014a6d8,%eax
8010324e:	83 e8 01             	sub    $0x1,%eax
80103251:	39 c2                	cmp    %eax,%edx
80103253:	7d 79                	jge    801032ce <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103255:	a1 dc a6 14 80       	mov    0x8014a6dc,%eax
8010325a:	85 c0                	test   %eax,%eax
8010325c:	7e 7d                	jle    801032db <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010325e:	83 ec 0c             	sub    $0xc,%esp
80103261:	68 a0 a6 14 80       	push   $0x8014a6a0
80103266:	e8 25 16 00 00       	call   80104890 <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010326b:	8b 15 e8 a6 14 80    	mov    0x8014a6e8,%edx
80103271:	83 c4 10             	add    $0x10,%esp
80103274:	85 d2                	test   %edx,%edx
80103276:	7e 4a                	jle    801032c2 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103278:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010327b:	31 c0                	xor    %eax,%eax
8010327d:	eb 08                	jmp    80103287 <log_write+0x57>
8010327f:	90                   	nop
80103280:	83 c0 01             	add    $0x1,%eax
80103283:	39 c2                	cmp    %eax,%edx
80103285:	74 29                	je     801032b0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103287:	39 0c 85 ec a6 14 80 	cmp    %ecx,-0x7feb5914(,%eax,4)
8010328e:	75 f0                	jne    80103280 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80103290:	89 0c 85 ec a6 14 80 	mov    %ecx,-0x7feb5914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103297:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010329a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010329d:	c7 45 08 a0 a6 14 80 	movl   $0x8014a6a0,0x8(%ebp)
}
801032a4:	c9                   	leave  
  release(&log.lock);
801032a5:	e9 86 15 00 00       	jmp    80104830 <release>
801032aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801032b0:	89 0c 95 ec a6 14 80 	mov    %ecx,-0x7feb5914(,%edx,4)
    log.lh.n++;
801032b7:	83 c2 01             	add    $0x1,%edx
801032ba:	89 15 e8 a6 14 80    	mov    %edx,0x8014a6e8
801032c0:	eb d5                	jmp    80103297 <log_write+0x67>
  log.lh.block[i] = b->blockno;
801032c2:	8b 43 08             	mov    0x8(%ebx),%eax
801032c5:	a3 ec a6 14 80       	mov    %eax,0x8014a6ec
  if (i == log.lh.n)
801032ca:	75 cb                	jne    80103297 <log_write+0x67>
801032cc:	eb e9                	jmp    801032b7 <log_write+0x87>
    panic("too big a transaction");
801032ce:	83 ec 0c             	sub    $0xc,%esp
801032d1:	68 93 7b 10 80       	push   $0x80107b93
801032d6:	e8 a5 d0 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
801032db:	83 ec 0c             	sub    $0xc,%esp
801032de:	68 a9 7b 10 80       	push   $0x80107ba9
801032e3:	e8 98 d0 ff ff       	call   80100380 <panic>
801032e8:	66 90                	xchg   %ax,%ax
801032ea:	66 90                	xchg   %ax,%ax
801032ec:	66 90                	xchg   %ax,%ax
801032ee:	66 90                	xchg   %ax,%ax

801032f0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801032f0:	55                   	push   %ebp
801032f1:	89 e5                	mov    %esp,%ebp
801032f3:	53                   	push   %ebx
801032f4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801032f7:	e8 44 09 00 00       	call   80103c40 <cpuid>
801032fc:	89 c3                	mov    %eax,%ebx
801032fe:	e8 3d 09 00 00       	call   80103c40 <cpuid>
80103303:	83 ec 04             	sub    $0x4,%esp
80103306:	53                   	push   %ebx
80103307:	50                   	push   %eax
80103308:	68 c4 7b 10 80       	push   $0x80107bc4
8010330d:	e8 8e d3 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103312:	e8 b9 28 00 00       	call   80105bd0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103317:	e8 c4 08 00 00       	call   80103be0 <mycpu>
8010331c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010331e:	b8 01 00 00 00       	mov    $0x1,%eax
80103323:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010332a:	e8 f1 0b 00 00       	call   80103f20 <scheduler>
8010332f:	90                   	nop

80103330 <mpenter>:
{
80103330:	55                   	push   %ebp
80103331:	89 e5                	mov    %esp,%ebp
80103333:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103336:	e8 c5 39 00 00       	call   80106d00 <switchkvm>
  seginit();
8010333b:	e8 30 39 00 00       	call   80106c70 <seginit>
  lapicinit();
80103340:	e8 9b f7 ff ff       	call   80102ae0 <lapicinit>
  mpmain();
80103345:	e8 a6 ff ff ff       	call   801032f0 <mpmain>
8010334a:	66 90                	xchg   %ax,%ax
8010334c:	66 90                	xchg   %ax,%ax
8010334e:	66 90                	xchg   %ax,%ax

80103350 <main>:
{
80103350:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103354:	83 e4 f0             	and    $0xfffffff0,%esp
80103357:	ff 71 fc             	push   -0x4(%ecx)
8010335a:	55                   	push   %ebp
8010335b:	89 e5                	mov    %esp,%ebp
8010335d:	53                   	push   %ebx
8010335e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010335f:	83 ec 08             	sub    $0x8,%esp
80103362:	68 00 00 40 80       	push   $0x80400000
80103367:	68 d0 e4 14 80       	push   $0x8014e4d0
8010336c:	e8 1f f3 ff ff       	call   80102690 <kinit1>
  kvmalloc();      // kernel page table
80103371:	e8 7a 3e 00 00       	call   801071f0 <kvmalloc>
  mpinit();        // detect other processors
80103376:	e8 85 01 00 00       	call   80103500 <mpinit>
  lapicinit();     // interrupt controller
8010337b:	e8 60 f7 ff ff       	call   80102ae0 <lapicinit>
  seginit();       // segment descriptors
80103380:	e8 eb 38 00 00       	call   80106c70 <seginit>
  picinit();       // disable pic
80103385:	e8 76 03 00 00       	call   80103700 <picinit>
  ioapicinit();    // another interrupt controller
8010338a:	e8 41 f0 ff ff       	call   801023d0 <ioapicinit>
  consoleinit();   // console hardware
8010338f:	e8 cc d6 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
80103394:	e8 47 2b 00 00       	call   80105ee0 <uartinit>
  pinit();         // process table
80103399:	e8 22 08 00 00       	call   80103bc0 <pinit>
  tvinit();        // trap vectors
8010339e:	e8 ad 27 00 00       	call   80105b50 <tvinit>
  binit();         // buffer cache
801033a3:	e8 98 cc ff ff       	call   80100040 <binit>
  fileinit();      // file table
801033a8:	e8 63 da ff ff       	call   80100e10 <fileinit>
  ideinit();       // disk 
801033ad:	e8 0e ee ff ff       	call   801021c0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801033b2:	83 c4 0c             	add    $0xc,%esp
801033b5:	68 8a 00 00 00       	push   $0x8a
801033ba:	68 8c b4 10 80       	push   $0x8010b48c
801033bf:	68 00 70 00 80       	push   $0x80007000
801033c4:	e8 27 16 00 00       	call   801049f0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801033c9:	83 c4 10             	add    $0x10,%esp
801033cc:	69 05 84 a7 14 80 b0 	imul   $0xb0,0x8014a784,%eax
801033d3:	00 00 00 
801033d6:	05 a0 a7 14 80       	add    $0x8014a7a0,%eax
801033db:	3d a0 a7 14 80       	cmp    $0x8014a7a0,%eax
801033e0:	76 7e                	jbe    80103460 <main+0x110>
801033e2:	bb a0 a7 14 80       	mov    $0x8014a7a0,%ebx
801033e7:	eb 20                	jmp    80103409 <main+0xb9>
801033e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033f0:	69 05 84 a7 14 80 b0 	imul   $0xb0,0x8014a784,%eax
801033f7:	00 00 00 
801033fa:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103400:	05 a0 a7 14 80       	add    $0x8014a7a0,%eax
80103405:	39 c3                	cmp    %eax,%ebx
80103407:	73 57                	jae    80103460 <main+0x110>
    if(c == mycpu())  // We've started already.
80103409:	e8 d2 07 00 00       	call   80103be0 <mycpu>
8010340e:	39 c3                	cmp    %eax,%ebx
80103410:	74 de                	je     801033f0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103412:	e8 09 f3 ff ff       	call   80102720 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103417:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010341a:	c7 05 f8 6f 00 80 30 	movl   $0x80103330,0x80006ff8
80103421:	33 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103424:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010342b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010342e:	05 00 10 00 00       	add    $0x1000,%eax
80103433:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103438:	0f b6 03             	movzbl (%ebx),%eax
8010343b:	68 00 70 00 00       	push   $0x7000
80103440:	50                   	push   %eax
80103441:	e8 ea f7 ff ff       	call   80102c30 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103446:	83 c4 10             	add    $0x10,%esp
80103449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103450:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103456:	85 c0                	test   %eax,%eax
80103458:	74 f6                	je     80103450 <main+0x100>
8010345a:	eb 94                	jmp    801033f0 <main+0xa0>
8010345c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103460:	83 ec 08             	sub    $0x8,%esp
80103463:	68 00 00 00 8e       	push   $0x8e000000
80103468:	68 00 00 40 80       	push   $0x80400000
8010346d:	e8 9e f1 ff ff       	call   80102610 <kinit2>
  userinit();      // first user process
80103472:	e8 19 08 00 00       	call   80103c90 <userinit>
  mpmain();        // finish this processor's setup
80103477:	e8 74 fe ff ff       	call   801032f0 <mpmain>
8010347c:	66 90                	xchg   %ax,%ax
8010347e:	66 90                	xchg   %ax,%ax

80103480 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103480:	55                   	push   %ebp
80103481:	89 e5                	mov    %esp,%ebp
80103483:	57                   	push   %edi
80103484:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103485:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010348b:	53                   	push   %ebx
  e = addr+len;
8010348c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010348f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103492:	39 de                	cmp    %ebx,%esi
80103494:	72 10                	jb     801034a6 <mpsearch1+0x26>
80103496:	eb 50                	jmp    801034e8 <mpsearch1+0x68>
80103498:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010349f:	90                   	nop
801034a0:	89 fe                	mov    %edi,%esi
801034a2:	39 fb                	cmp    %edi,%ebx
801034a4:	76 42                	jbe    801034e8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801034a6:	83 ec 04             	sub    $0x4,%esp
801034a9:	8d 7e 10             	lea    0x10(%esi),%edi
801034ac:	6a 04                	push   $0x4
801034ae:	68 d8 7b 10 80       	push   $0x80107bd8
801034b3:	56                   	push   %esi
801034b4:	e8 e7 14 00 00       	call   801049a0 <memcmp>
801034b9:	83 c4 10             	add    $0x10,%esp
801034bc:	85 c0                	test   %eax,%eax
801034be:	75 e0                	jne    801034a0 <mpsearch1+0x20>
801034c0:	89 f2                	mov    %esi,%edx
801034c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801034c8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801034cb:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801034ce:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801034d0:	39 fa                	cmp    %edi,%edx
801034d2:	75 f4                	jne    801034c8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801034d4:	84 c0                	test   %al,%al
801034d6:	75 c8                	jne    801034a0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801034d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034db:	89 f0                	mov    %esi,%eax
801034dd:	5b                   	pop    %ebx
801034de:	5e                   	pop    %esi
801034df:	5f                   	pop    %edi
801034e0:	5d                   	pop    %ebp
801034e1:	c3                   	ret    
801034e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801034e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034eb:	31 f6                	xor    %esi,%esi
}
801034ed:	5b                   	pop    %ebx
801034ee:	89 f0                	mov    %esi,%eax
801034f0:	5e                   	pop    %esi
801034f1:	5f                   	pop    %edi
801034f2:	5d                   	pop    %ebp
801034f3:	c3                   	ret    
801034f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034ff:	90                   	nop

80103500 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103500:	55                   	push   %ebp
80103501:	89 e5                	mov    %esp,%ebp
80103503:	57                   	push   %edi
80103504:	56                   	push   %esi
80103505:	53                   	push   %ebx
80103506:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103509:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103510:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103517:	c1 e0 08             	shl    $0x8,%eax
8010351a:	09 d0                	or     %edx,%eax
8010351c:	c1 e0 04             	shl    $0x4,%eax
8010351f:	75 1b                	jne    8010353c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103521:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103528:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010352f:	c1 e0 08             	shl    $0x8,%eax
80103532:	09 d0                	or     %edx,%eax
80103534:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103537:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010353c:	ba 00 04 00 00       	mov    $0x400,%edx
80103541:	e8 3a ff ff ff       	call   80103480 <mpsearch1>
80103546:	89 c3                	mov    %eax,%ebx
80103548:	85 c0                	test   %eax,%eax
8010354a:	0f 84 40 01 00 00    	je     80103690 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103550:	8b 73 04             	mov    0x4(%ebx),%esi
80103553:	85 f6                	test   %esi,%esi
80103555:	0f 84 25 01 00 00    	je     80103680 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010355b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010355e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103564:	6a 04                	push   $0x4
80103566:	68 dd 7b 10 80       	push   $0x80107bdd
8010356b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010356c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010356f:	e8 2c 14 00 00       	call   801049a0 <memcmp>
80103574:	83 c4 10             	add    $0x10,%esp
80103577:	85 c0                	test   %eax,%eax
80103579:	0f 85 01 01 00 00    	jne    80103680 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010357f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103586:	3c 01                	cmp    $0x1,%al
80103588:	74 08                	je     80103592 <mpinit+0x92>
8010358a:	3c 04                	cmp    $0x4,%al
8010358c:	0f 85 ee 00 00 00    	jne    80103680 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
80103592:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103599:	66 85 d2             	test   %dx,%dx
8010359c:	74 22                	je     801035c0 <mpinit+0xc0>
8010359e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801035a1:	89 f0                	mov    %esi,%eax
  sum = 0;
801035a3:	31 d2                	xor    %edx,%edx
801035a5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801035a8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801035af:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801035b2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801035b4:	39 c7                	cmp    %eax,%edi
801035b6:	75 f0                	jne    801035a8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801035b8:	84 d2                	test   %dl,%dl
801035ba:	0f 85 c0 00 00 00    	jne    80103680 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801035c0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801035c6:	a3 84 a6 14 80       	mov    %eax,0x8014a684
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801035cb:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801035d2:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
801035d8:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801035dd:	03 55 e4             	add    -0x1c(%ebp),%edx
801035e0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801035e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035e7:	90                   	nop
801035e8:	39 d0                	cmp    %edx,%eax
801035ea:	73 15                	jae    80103601 <mpinit+0x101>
    switch(*p){
801035ec:	0f b6 08             	movzbl (%eax),%ecx
801035ef:	80 f9 02             	cmp    $0x2,%cl
801035f2:	74 4c                	je     80103640 <mpinit+0x140>
801035f4:	77 3a                	ja     80103630 <mpinit+0x130>
801035f6:	84 c9                	test   %cl,%cl
801035f8:	74 56                	je     80103650 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801035fa:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801035fd:	39 d0                	cmp    %edx,%eax
801035ff:	72 eb                	jb     801035ec <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103601:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103604:	85 f6                	test   %esi,%esi
80103606:	0f 84 d9 00 00 00    	je     801036e5 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010360c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103610:	74 15                	je     80103627 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103612:	b8 70 00 00 00       	mov    $0x70,%eax
80103617:	ba 22 00 00 00       	mov    $0x22,%edx
8010361c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010361d:	ba 23 00 00 00       	mov    $0x23,%edx
80103622:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103623:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103626:	ee                   	out    %al,(%dx)
  }
}
80103627:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010362a:	5b                   	pop    %ebx
8010362b:	5e                   	pop    %esi
8010362c:	5f                   	pop    %edi
8010362d:	5d                   	pop    %ebp
8010362e:	c3                   	ret    
8010362f:	90                   	nop
    switch(*p){
80103630:	83 e9 03             	sub    $0x3,%ecx
80103633:	80 f9 01             	cmp    $0x1,%cl
80103636:	76 c2                	jbe    801035fa <mpinit+0xfa>
80103638:	31 f6                	xor    %esi,%esi
8010363a:	eb ac                	jmp    801035e8 <mpinit+0xe8>
8010363c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103640:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103644:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103647:	88 0d 80 a7 14 80    	mov    %cl,0x8014a780
      continue;
8010364d:	eb 99                	jmp    801035e8 <mpinit+0xe8>
8010364f:	90                   	nop
      if(ncpu < NCPU) {
80103650:	8b 0d 84 a7 14 80    	mov    0x8014a784,%ecx
80103656:	83 f9 07             	cmp    $0x7,%ecx
80103659:	7f 19                	jg     80103674 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010365b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103661:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103665:	83 c1 01             	add    $0x1,%ecx
80103668:	89 0d 84 a7 14 80    	mov    %ecx,0x8014a784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010366e:	88 9f a0 a7 14 80    	mov    %bl,-0x7feb5860(%edi)
      p += sizeof(struct mpproc);
80103674:	83 c0 14             	add    $0x14,%eax
      continue;
80103677:	e9 6c ff ff ff       	jmp    801035e8 <mpinit+0xe8>
8010367c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103680:	83 ec 0c             	sub    $0xc,%esp
80103683:	68 e2 7b 10 80       	push   $0x80107be2
80103688:	e8 f3 cc ff ff       	call   80100380 <panic>
8010368d:	8d 76 00             	lea    0x0(%esi),%esi
{
80103690:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
80103695:	eb 13                	jmp    801036aa <mpinit+0x1aa>
80103697:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010369e:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
801036a0:	89 f3                	mov    %esi,%ebx
801036a2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801036a8:	74 d6                	je     80103680 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801036aa:	83 ec 04             	sub    $0x4,%esp
801036ad:	8d 73 10             	lea    0x10(%ebx),%esi
801036b0:	6a 04                	push   $0x4
801036b2:	68 d8 7b 10 80       	push   $0x80107bd8
801036b7:	53                   	push   %ebx
801036b8:	e8 e3 12 00 00       	call   801049a0 <memcmp>
801036bd:	83 c4 10             	add    $0x10,%esp
801036c0:	85 c0                	test   %eax,%eax
801036c2:	75 dc                	jne    801036a0 <mpinit+0x1a0>
801036c4:	89 da                	mov    %ebx,%edx
801036c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036cd:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801036d0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801036d3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801036d6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801036d8:	39 d6                	cmp    %edx,%esi
801036da:	75 f4                	jne    801036d0 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801036dc:	84 c0                	test   %al,%al
801036de:	75 c0                	jne    801036a0 <mpinit+0x1a0>
801036e0:	e9 6b fe ff ff       	jmp    80103550 <mpinit+0x50>
    panic("Didn't find a suitable machine");
801036e5:	83 ec 0c             	sub    $0xc,%esp
801036e8:	68 fc 7b 10 80       	push   $0x80107bfc
801036ed:	e8 8e cc ff ff       	call   80100380 <panic>
801036f2:	66 90                	xchg   %ax,%ax
801036f4:	66 90                	xchg   %ax,%ax
801036f6:	66 90                	xchg   %ax,%ax
801036f8:	66 90                	xchg   %ax,%ax
801036fa:	66 90                	xchg   %ax,%ax
801036fc:	66 90                	xchg   %ax,%ax
801036fe:	66 90                	xchg   %ax,%ax

80103700 <picinit>:
80103700:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103705:	ba 21 00 00 00       	mov    $0x21,%edx
8010370a:	ee                   	out    %al,(%dx)
8010370b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103710:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103711:	c3                   	ret    
80103712:	66 90                	xchg   %ax,%ax
80103714:	66 90                	xchg   %ax,%ax
80103716:	66 90                	xchg   %ax,%ax
80103718:	66 90                	xchg   %ax,%ax
8010371a:	66 90                	xchg   %ax,%ax
8010371c:	66 90                	xchg   %ax,%ax
8010371e:	66 90                	xchg   %ax,%ax

80103720 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103720:	55                   	push   %ebp
80103721:	89 e5                	mov    %esp,%ebp
80103723:	57                   	push   %edi
80103724:	56                   	push   %esi
80103725:	53                   	push   %ebx
80103726:	83 ec 0c             	sub    $0xc,%esp
80103729:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010372c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010372f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103735:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010373b:	e8 f0 d6 ff ff       	call   80100e30 <filealloc>
80103740:	89 03                	mov    %eax,(%ebx)
80103742:	85 c0                	test   %eax,%eax
80103744:	0f 84 a8 00 00 00    	je     801037f2 <pipealloc+0xd2>
8010374a:	e8 e1 d6 ff ff       	call   80100e30 <filealloc>
8010374f:	89 06                	mov    %eax,(%esi)
80103751:	85 c0                	test   %eax,%eax
80103753:	0f 84 87 00 00 00    	je     801037e0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103759:	e8 c2 ef ff ff       	call   80102720 <kalloc>
8010375e:	89 c7                	mov    %eax,%edi
80103760:	85 c0                	test   %eax,%eax
80103762:	0f 84 b0 00 00 00    	je     80103818 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103768:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010376f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103772:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103775:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010377c:	00 00 00 
  p->nwrite = 0;
8010377f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103786:	00 00 00 
  p->nread = 0;
80103789:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103790:	00 00 00 
  initlock(&p->lock, "pipe");
80103793:	68 1b 7c 10 80       	push   $0x80107c1b
80103798:	50                   	push   %eax
80103799:	e8 22 0f 00 00       	call   801046c0 <initlock>
  (*f0)->type = FD_PIPE;
8010379e:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801037a0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801037a3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801037a9:	8b 03                	mov    (%ebx),%eax
801037ab:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801037af:	8b 03                	mov    (%ebx),%eax
801037b1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801037b5:	8b 03                	mov    (%ebx),%eax
801037b7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801037ba:	8b 06                	mov    (%esi),%eax
801037bc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801037c2:	8b 06                	mov    (%esi),%eax
801037c4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801037c8:	8b 06                	mov    (%esi),%eax
801037ca:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801037ce:	8b 06                	mov    (%esi),%eax
801037d0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801037d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801037d6:	31 c0                	xor    %eax,%eax
}
801037d8:	5b                   	pop    %ebx
801037d9:	5e                   	pop    %esi
801037da:	5f                   	pop    %edi
801037db:	5d                   	pop    %ebp
801037dc:	c3                   	ret    
801037dd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
801037e0:	8b 03                	mov    (%ebx),%eax
801037e2:	85 c0                	test   %eax,%eax
801037e4:	74 1e                	je     80103804 <pipealloc+0xe4>
    fileclose(*f0);
801037e6:	83 ec 0c             	sub    $0xc,%esp
801037e9:	50                   	push   %eax
801037ea:	e8 01 d7 ff ff       	call   80100ef0 <fileclose>
801037ef:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801037f2:	8b 06                	mov    (%esi),%eax
801037f4:	85 c0                	test   %eax,%eax
801037f6:	74 0c                	je     80103804 <pipealloc+0xe4>
    fileclose(*f1);
801037f8:	83 ec 0c             	sub    $0xc,%esp
801037fb:	50                   	push   %eax
801037fc:	e8 ef d6 ff ff       	call   80100ef0 <fileclose>
80103801:	83 c4 10             	add    $0x10,%esp
}
80103804:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103807:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010380c:	5b                   	pop    %ebx
8010380d:	5e                   	pop    %esi
8010380e:	5f                   	pop    %edi
8010380f:	5d                   	pop    %ebp
80103810:	c3                   	ret    
80103811:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103818:	8b 03                	mov    (%ebx),%eax
8010381a:	85 c0                	test   %eax,%eax
8010381c:	75 c8                	jne    801037e6 <pipealloc+0xc6>
8010381e:	eb d2                	jmp    801037f2 <pipealloc+0xd2>

80103820 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103820:	55                   	push   %ebp
80103821:	89 e5                	mov    %esp,%ebp
80103823:	56                   	push   %esi
80103824:	53                   	push   %ebx
80103825:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103828:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010382b:	83 ec 0c             	sub    $0xc,%esp
8010382e:	53                   	push   %ebx
8010382f:	e8 5c 10 00 00       	call   80104890 <acquire>
  if(writable){
80103834:	83 c4 10             	add    $0x10,%esp
80103837:	85 f6                	test   %esi,%esi
80103839:	74 65                	je     801038a0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010383b:	83 ec 0c             	sub    $0xc,%esp
8010383e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103844:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010384b:	00 00 00 
    wakeup(&p->nread);
8010384e:	50                   	push   %eax
8010384f:	e8 9c 0b 00 00       	call   801043f0 <wakeup>
80103854:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103857:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010385d:	85 d2                	test   %edx,%edx
8010385f:	75 0a                	jne    8010386b <pipeclose+0x4b>
80103861:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103867:	85 c0                	test   %eax,%eax
80103869:	74 15                	je     80103880 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010386b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010386e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103871:	5b                   	pop    %ebx
80103872:	5e                   	pop    %esi
80103873:	5d                   	pop    %ebp
    release(&p->lock);
80103874:	e9 b7 0f 00 00       	jmp    80104830 <release>
80103879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103880:	83 ec 0c             	sub    $0xc,%esp
80103883:	53                   	push   %ebx
80103884:	e8 a7 0f 00 00       	call   80104830 <release>
    kfree((char*)p);
80103889:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010388c:	83 c4 10             	add    $0x10,%esp
}
8010388f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103892:	5b                   	pop    %ebx
80103893:	5e                   	pop    %esi
80103894:	5d                   	pop    %ebp
    kfree((char*)p);
80103895:	e9 26 ec ff ff       	jmp    801024c0 <kfree>
8010389a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801038a0:	83 ec 0c             	sub    $0xc,%esp
801038a3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801038a9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801038b0:	00 00 00 
    wakeup(&p->nwrite);
801038b3:	50                   	push   %eax
801038b4:	e8 37 0b 00 00       	call   801043f0 <wakeup>
801038b9:	83 c4 10             	add    $0x10,%esp
801038bc:	eb 99                	jmp    80103857 <pipeclose+0x37>
801038be:	66 90                	xchg   %ax,%ax

801038c0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801038c0:	55                   	push   %ebp
801038c1:	89 e5                	mov    %esp,%ebp
801038c3:	57                   	push   %edi
801038c4:	56                   	push   %esi
801038c5:	53                   	push   %ebx
801038c6:	83 ec 28             	sub    $0x28,%esp
801038c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801038cc:	53                   	push   %ebx
801038cd:	e8 be 0f 00 00       	call   80104890 <acquire>
  for(i = 0; i < n; i++){
801038d2:	8b 45 10             	mov    0x10(%ebp),%eax
801038d5:	83 c4 10             	add    $0x10,%esp
801038d8:	85 c0                	test   %eax,%eax
801038da:	0f 8e c0 00 00 00    	jle    801039a0 <pipewrite+0xe0>
801038e0:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801038e3:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801038e9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801038ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801038f2:	03 45 10             	add    0x10(%ebp),%eax
801038f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801038f8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801038fe:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103904:	89 ca                	mov    %ecx,%edx
80103906:	05 00 02 00 00       	add    $0x200,%eax
8010390b:	39 c1                	cmp    %eax,%ecx
8010390d:	74 3f                	je     8010394e <pipewrite+0x8e>
8010390f:	eb 67                	jmp    80103978 <pipewrite+0xb8>
80103911:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103918:	e8 43 03 00 00       	call   80103c60 <myproc>
8010391d:	8b 48 24             	mov    0x24(%eax),%ecx
80103920:	85 c9                	test   %ecx,%ecx
80103922:	75 34                	jne    80103958 <pipewrite+0x98>
      wakeup(&p->nread);
80103924:	83 ec 0c             	sub    $0xc,%esp
80103927:	57                   	push   %edi
80103928:	e8 c3 0a 00 00       	call   801043f0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010392d:	58                   	pop    %eax
8010392e:	5a                   	pop    %edx
8010392f:	53                   	push   %ebx
80103930:	56                   	push   %esi
80103931:	e8 fa 09 00 00       	call   80104330 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103936:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010393c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103942:	83 c4 10             	add    $0x10,%esp
80103945:	05 00 02 00 00       	add    $0x200,%eax
8010394a:	39 c2                	cmp    %eax,%edx
8010394c:	75 2a                	jne    80103978 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010394e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103954:	85 c0                	test   %eax,%eax
80103956:	75 c0                	jne    80103918 <pipewrite+0x58>
        release(&p->lock);
80103958:	83 ec 0c             	sub    $0xc,%esp
8010395b:	53                   	push   %ebx
8010395c:	e8 cf 0e 00 00       	call   80104830 <release>
        return -1;
80103961:	83 c4 10             	add    $0x10,%esp
80103964:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103969:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010396c:	5b                   	pop    %ebx
8010396d:	5e                   	pop    %esi
8010396e:	5f                   	pop    %edi
8010396f:	5d                   	pop    %ebp
80103970:	c3                   	ret    
80103971:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103978:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010397b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010397e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103984:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010398a:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
8010398d:	83 c6 01             	add    $0x1,%esi
80103990:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103993:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103997:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010399a:	0f 85 58 ff ff ff    	jne    801038f8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801039a0:	83 ec 0c             	sub    $0xc,%esp
801039a3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801039a9:	50                   	push   %eax
801039aa:	e8 41 0a 00 00       	call   801043f0 <wakeup>
  release(&p->lock);
801039af:	89 1c 24             	mov    %ebx,(%esp)
801039b2:	e8 79 0e 00 00       	call   80104830 <release>
  return n;
801039b7:	8b 45 10             	mov    0x10(%ebp),%eax
801039ba:	83 c4 10             	add    $0x10,%esp
801039bd:	eb aa                	jmp    80103969 <pipewrite+0xa9>
801039bf:	90                   	nop

801039c0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801039c0:	55                   	push   %ebp
801039c1:	89 e5                	mov    %esp,%ebp
801039c3:	57                   	push   %edi
801039c4:	56                   	push   %esi
801039c5:	53                   	push   %ebx
801039c6:	83 ec 18             	sub    $0x18,%esp
801039c9:	8b 75 08             	mov    0x8(%ebp),%esi
801039cc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801039cf:	56                   	push   %esi
801039d0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801039d6:	e8 b5 0e 00 00       	call   80104890 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801039db:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801039e1:	83 c4 10             	add    $0x10,%esp
801039e4:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801039ea:	74 2f                	je     80103a1b <piperead+0x5b>
801039ec:	eb 37                	jmp    80103a25 <piperead+0x65>
801039ee:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
801039f0:	e8 6b 02 00 00       	call   80103c60 <myproc>
801039f5:	8b 48 24             	mov    0x24(%eax),%ecx
801039f8:	85 c9                	test   %ecx,%ecx
801039fa:	0f 85 80 00 00 00    	jne    80103a80 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103a00:	83 ec 08             	sub    $0x8,%esp
80103a03:	56                   	push   %esi
80103a04:	53                   	push   %ebx
80103a05:	e8 26 09 00 00       	call   80104330 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103a0a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103a10:	83 c4 10             	add    $0x10,%esp
80103a13:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103a19:	75 0a                	jne    80103a25 <piperead+0x65>
80103a1b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103a21:	85 c0                	test   %eax,%eax
80103a23:	75 cb                	jne    801039f0 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103a25:	8b 55 10             	mov    0x10(%ebp),%edx
80103a28:	31 db                	xor    %ebx,%ebx
80103a2a:	85 d2                	test   %edx,%edx
80103a2c:	7f 20                	jg     80103a4e <piperead+0x8e>
80103a2e:	eb 2c                	jmp    80103a5c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103a30:	8d 48 01             	lea    0x1(%eax),%ecx
80103a33:	25 ff 01 00 00       	and    $0x1ff,%eax
80103a38:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103a3e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103a43:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103a46:	83 c3 01             	add    $0x1,%ebx
80103a49:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103a4c:	74 0e                	je     80103a5c <piperead+0x9c>
    if(p->nread == p->nwrite)
80103a4e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103a54:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103a5a:	75 d4                	jne    80103a30 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103a5c:	83 ec 0c             	sub    $0xc,%esp
80103a5f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103a65:	50                   	push   %eax
80103a66:	e8 85 09 00 00       	call   801043f0 <wakeup>
  release(&p->lock);
80103a6b:	89 34 24             	mov    %esi,(%esp)
80103a6e:	e8 bd 0d 00 00       	call   80104830 <release>
  return i;
80103a73:	83 c4 10             	add    $0x10,%esp
}
80103a76:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a79:	89 d8                	mov    %ebx,%eax
80103a7b:	5b                   	pop    %ebx
80103a7c:	5e                   	pop    %esi
80103a7d:	5f                   	pop    %edi
80103a7e:	5d                   	pop    %ebp
80103a7f:	c3                   	ret    
      release(&p->lock);
80103a80:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103a83:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103a88:	56                   	push   %esi
80103a89:	e8 a2 0d 00 00       	call   80104830 <release>
      return -1;
80103a8e:	83 c4 10             	add    $0x10,%esp
}
80103a91:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a94:	89 d8                	mov    %ebx,%eax
80103a96:	5b                   	pop    %ebx
80103a97:	5e                   	pop    %esi
80103a98:	5f                   	pop    %edi
80103a99:	5d                   	pop    %ebp
80103a9a:	c3                   	ret    
80103a9b:	66 90                	xchg   %ax,%ax
80103a9d:	66 90                	xchg   %ax,%ax
80103a9f:	90                   	nop

80103aa0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103aa0:	55                   	push   %ebp
80103aa1:	89 e5                	mov    %esp,%ebp
80103aa3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103aa4:	bb 54 ad 14 80       	mov    $0x8014ad54,%ebx
{
80103aa9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103aac:	68 20 ad 14 80       	push   $0x8014ad20
80103ab1:	e8 da 0d 00 00       	call   80104890 <acquire>
80103ab6:	83 c4 10             	add    $0x10,%esp
80103ab9:	eb 10                	jmp    80103acb <allocproc+0x2b>
80103abb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103abf:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ac0:	83 c3 7c             	add    $0x7c,%ebx
80103ac3:	81 fb 54 cc 14 80    	cmp    $0x8014cc54,%ebx
80103ac9:	74 75                	je     80103b40 <allocproc+0xa0>
    if(p->state == UNUSED)
80103acb:	8b 43 0c             	mov    0xc(%ebx),%eax
80103ace:	85 c0                	test   %eax,%eax
80103ad0:	75 ee                	jne    80103ac0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103ad2:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103ad7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103ada:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103ae1:	89 43 10             	mov    %eax,0x10(%ebx)
80103ae4:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103ae7:	68 20 ad 14 80       	push   $0x8014ad20
  p->pid = nextpid++;
80103aec:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103af2:	e8 39 0d 00 00       	call   80104830 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103af7:	e8 24 ec ff ff       	call   80102720 <kalloc>
80103afc:	83 c4 10             	add    $0x10,%esp
80103aff:	89 43 08             	mov    %eax,0x8(%ebx)
80103b02:	85 c0                	test   %eax,%eax
80103b04:	74 53                	je     80103b59 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103b06:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103b0c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103b0f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103b14:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103b17:	c7 40 14 42 5b 10 80 	movl   $0x80105b42,0x14(%eax)
  p->context = (struct context*)sp;
80103b1e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103b21:	6a 14                	push   $0x14
80103b23:	6a 00                	push   $0x0
80103b25:	50                   	push   %eax
80103b26:	e8 25 0e 00 00       	call   80104950 <memset>
  p->context->eip = (uint)forkret;
80103b2b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103b2e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103b31:	c7 40 10 70 3b 10 80 	movl   $0x80103b70,0x10(%eax)
}
80103b38:	89 d8                	mov    %ebx,%eax
80103b3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b3d:	c9                   	leave  
80103b3e:	c3                   	ret    
80103b3f:	90                   	nop
  release(&ptable.lock);
80103b40:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103b43:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103b45:	68 20 ad 14 80       	push   $0x8014ad20
80103b4a:	e8 e1 0c 00 00       	call   80104830 <release>
}
80103b4f:	89 d8                	mov    %ebx,%eax
  return 0;
80103b51:	83 c4 10             	add    $0x10,%esp
}
80103b54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b57:	c9                   	leave  
80103b58:	c3                   	ret    
    p->state = UNUSED;
80103b59:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103b60:	31 db                	xor    %ebx,%ebx
}
80103b62:	89 d8                	mov    %ebx,%eax
80103b64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b67:	c9                   	leave  
80103b68:	c3                   	ret    
80103b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103b70 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103b70:	55                   	push   %ebp
80103b71:	89 e5                	mov    %esp,%ebp
80103b73:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103b76:	68 20 ad 14 80       	push   $0x8014ad20
80103b7b:	e8 b0 0c 00 00       	call   80104830 <release>

  if (first) {
80103b80:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103b85:	83 c4 10             	add    $0x10,%esp
80103b88:	85 c0                	test   %eax,%eax
80103b8a:	75 04                	jne    80103b90 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103b8c:	c9                   	leave  
80103b8d:	c3                   	ret    
80103b8e:	66 90                	xchg   %ax,%ax
    first = 0;
80103b90:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103b97:	00 00 00 
    iinit(ROOTDEV);
80103b9a:	83 ec 0c             	sub    $0xc,%esp
80103b9d:	6a 01                	push   $0x1
80103b9f:	e8 bc d9 ff ff       	call   80101560 <iinit>
    initlog(ROOTDEV);
80103ba4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103bab:	e8 00 f4 ff ff       	call   80102fb0 <initlog>
}
80103bb0:	83 c4 10             	add    $0x10,%esp
80103bb3:	c9                   	leave  
80103bb4:	c3                   	ret    
80103bb5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103bc0 <pinit>:
{
80103bc0:	55                   	push   %ebp
80103bc1:	89 e5                	mov    %esp,%ebp
80103bc3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103bc6:	68 20 7c 10 80       	push   $0x80107c20
80103bcb:	68 20 ad 14 80       	push   $0x8014ad20
80103bd0:	e8 eb 0a 00 00       	call   801046c0 <initlock>
}
80103bd5:	83 c4 10             	add    $0x10,%esp
80103bd8:	c9                   	leave  
80103bd9:	c3                   	ret    
80103bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103be0 <mycpu>:
{
80103be0:	55                   	push   %ebp
80103be1:	89 e5                	mov    %esp,%ebp
80103be3:	56                   	push   %esi
80103be4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103be5:	9c                   	pushf  
80103be6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103be7:	f6 c4 02             	test   $0x2,%ah
80103bea:	75 46                	jne    80103c32 <mycpu+0x52>
  apicid = lapicid();
80103bec:	e8 ef ef ff ff       	call   80102be0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103bf1:	8b 35 84 a7 14 80    	mov    0x8014a784,%esi
80103bf7:	85 f6                	test   %esi,%esi
80103bf9:	7e 2a                	jle    80103c25 <mycpu+0x45>
80103bfb:	31 d2                	xor    %edx,%edx
80103bfd:	eb 08                	jmp    80103c07 <mycpu+0x27>
80103bff:	90                   	nop
80103c00:	83 c2 01             	add    $0x1,%edx
80103c03:	39 f2                	cmp    %esi,%edx
80103c05:	74 1e                	je     80103c25 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103c07:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103c0d:	0f b6 99 a0 a7 14 80 	movzbl -0x7feb5860(%ecx),%ebx
80103c14:	39 c3                	cmp    %eax,%ebx
80103c16:	75 e8                	jne    80103c00 <mycpu+0x20>
}
80103c18:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103c1b:	8d 81 a0 a7 14 80    	lea    -0x7feb5860(%ecx),%eax
}
80103c21:	5b                   	pop    %ebx
80103c22:	5e                   	pop    %esi
80103c23:	5d                   	pop    %ebp
80103c24:	c3                   	ret    
  panic("unknown apicid\n");
80103c25:	83 ec 0c             	sub    $0xc,%esp
80103c28:	68 27 7c 10 80       	push   $0x80107c27
80103c2d:	e8 4e c7 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103c32:	83 ec 0c             	sub    $0xc,%esp
80103c35:	68 04 7d 10 80       	push   $0x80107d04
80103c3a:	e8 41 c7 ff ff       	call   80100380 <panic>
80103c3f:	90                   	nop

80103c40 <cpuid>:
cpuid() {
80103c40:	55                   	push   %ebp
80103c41:	89 e5                	mov    %esp,%ebp
80103c43:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103c46:	e8 95 ff ff ff       	call   80103be0 <mycpu>
}
80103c4b:	c9                   	leave  
  return mycpu()-cpus;
80103c4c:	2d a0 a7 14 80       	sub    $0x8014a7a0,%eax
80103c51:	c1 f8 04             	sar    $0x4,%eax
80103c54:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103c5a:	c3                   	ret    
80103c5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c5f:	90                   	nop

80103c60 <myproc>:
myproc(void) {
80103c60:	55                   	push   %ebp
80103c61:	89 e5                	mov    %esp,%ebp
80103c63:	53                   	push   %ebx
80103c64:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103c67:	e8 d4 0a 00 00       	call   80104740 <pushcli>
  c = mycpu();
80103c6c:	e8 6f ff ff ff       	call   80103be0 <mycpu>
  p = c->proc;
80103c71:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c77:	e8 14 0b 00 00       	call   80104790 <popcli>
}
80103c7c:	89 d8                	mov    %ebx,%eax
80103c7e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c81:	c9                   	leave  
80103c82:	c3                   	ret    
80103c83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103c90 <userinit>:
{
80103c90:	55                   	push   %ebp
80103c91:	89 e5                	mov    %esp,%ebp
80103c93:	53                   	push   %ebx
80103c94:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103c97:	e8 04 fe ff ff       	call   80103aa0 <allocproc>
80103c9c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103c9e:	a3 54 cc 14 80       	mov    %eax,0x8014cc54
  if((p->pgdir = setupkvm()) == 0)
80103ca3:	e8 c8 34 00 00       	call   80107170 <setupkvm>
80103ca8:	89 43 04             	mov    %eax,0x4(%ebx)
80103cab:	85 c0                	test   %eax,%eax
80103cad:	0f 84 bd 00 00 00    	je     80103d70 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103cb3:	83 ec 04             	sub    $0x4,%esp
80103cb6:	68 2c 00 00 00       	push   $0x2c
80103cbb:	68 60 b4 10 80       	push   $0x8010b460
80103cc0:	50                   	push   %eax
80103cc1:	e8 5a 31 00 00       	call   80106e20 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103cc6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103cc9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103ccf:	6a 4c                	push   $0x4c
80103cd1:	6a 00                	push   $0x0
80103cd3:	ff 73 18             	push   0x18(%ebx)
80103cd6:	e8 75 0c 00 00       	call   80104950 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103cdb:	8b 43 18             	mov    0x18(%ebx),%eax
80103cde:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103ce3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103ce6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103ceb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103cef:	8b 43 18             	mov    0x18(%ebx),%eax
80103cf2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103cf6:	8b 43 18             	mov    0x18(%ebx),%eax
80103cf9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103cfd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103d01:	8b 43 18             	mov    0x18(%ebx),%eax
80103d04:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103d08:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103d0c:	8b 43 18             	mov    0x18(%ebx),%eax
80103d0f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103d16:	8b 43 18             	mov    0x18(%ebx),%eax
80103d19:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103d20:	8b 43 18             	mov    0x18(%ebx),%eax
80103d23:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103d2a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103d2d:	6a 10                	push   $0x10
80103d2f:	68 50 7c 10 80       	push   $0x80107c50
80103d34:	50                   	push   %eax
80103d35:	e8 d6 0d 00 00       	call   80104b10 <safestrcpy>
  p->cwd = namei("/");
80103d3a:	c7 04 24 59 7c 10 80 	movl   $0x80107c59,(%esp)
80103d41:	e8 5a e3 ff ff       	call   801020a0 <namei>
80103d46:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103d49:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
80103d50:	e8 3b 0b 00 00       	call   80104890 <acquire>
  p->state = RUNNABLE;
80103d55:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103d5c:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
80103d63:	e8 c8 0a 00 00       	call   80104830 <release>
}
80103d68:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d6b:	83 c4 10             	add    $0x10,%esp
80103d6e:	c9                   	leave  
80103d6f:	c3                   	ret    
    panic("userinit: out of memory?");
80103d70:	83 ec 0c             	sub    $0xc,%esp
80103d73:	68 37 7c 10 80       	push   $0x80107c37
80103d78:	e8 03 c6 ff ff       	call   80100380 <panic>
80103d7d:	8d 76 00             	lea    0x0(%esi),%esi

80103d80 <growproc>:
{
80103d80:	55                   	push   %ebp
80103d81:	89 e5                	mov    %esp,%ebp
80103d83:	56                   	push   %esi
80103d84:	53                   	push   %ebx
80103d85:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103d88:	e8 b3 09 00 00       	call   80104740 <pushcli>
  c = mycpu();
80103d8d:	e8 4e fe ff ff       	call   80103be0 <mycpu>
  p = c->proc;
80103d92:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d98:	e8 f3 09 00 00       	call   80104790 <popcli>
  sz = curproc->sz;
80103d9d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103d9f:	85 f6                	test   %esi,%esi
80103da1:	7f 1d                	jg     80103dc0 <growproc+0x40>
  } else if(n < 0){
80103da3:	75 3b                	jne    80103de0 <growproc+0x60>
  switchuvm(curproc);
80103da5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103da8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103daa:	53                   	push   %ebx
80103dab:	e8 60 2f 00 00       	call   80106d10 <switchuvm>
  return 0;
80103db0:	83 c4 10             	add    $0x10,%esp
80103db3:	31 c0                	xor    %eax,%eax
}
80103db5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103db8:	5b                   	pop    %ebx
80103db9:	5e                   	pop    %esi
80103dba:	5d                   	pop    %ebp
80103dbb:	c3                   	ret    
80103dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103dc0:	83 ec 04             	sub    $0x4,%esp
80103dc3:	01 c6                	add    %eax,%esi
80103dc5:	56                   	push   %esi
80103dc6:	50                   	push   %eax
80103dc7:	ff 73 04             	push   0x4(%ebx)
80103dca:	e8 c1 31 00 00       	call   80106f90 <allocuvm>
80103dcf:	83 c4 10             	add    $0x10,%esp
80103dd2:	85 c0                	test   %eax,%eax
80103dd4:	75 cf                	jne    80103da5 <growproc+0x25>
      return -1;
80103dd6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ddb:	eb d8                	jmp    80103db5 <growproc+0x35>
80103ddd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103de0:	83 ec 04             	sub    $0x4,%esp
80103de3:	01 c6                	add    %eax,%esi
80103de5:	56                   	push   %esi
80103de6:	50                   	push   %eax
80103de7:	ff 73 04             	push   0x4(%ebx)
80103dea:	e8 d1 32 00 00       	call   801070c0 <deallocuvm>
80103def:	83 c4 10             	add    $0x10,%esp
80103df2:	85 c0                	test   %eax,%eax
80103df4:	75 af                	jne    80103da5 <growproc+0x25>
80103df6:	eb de                	jmp    80103dd6 <growproc+0x56>
80103df8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dff:	90                   	nop

80103e00 <fork>:
{
80103e00:	55                   	push   %ebp
80103e01:	89 e5                	mov    %esp,%ebp
80103e03:	57                   	push   %edi
80103e04:	56                   	push   %esi
80103e05:	53                   	push   %ebx
80103e06:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103e09:	e8 32 09 00 00       	call   80104740 <pushcli>
  c = mycpu();
80103e0e:	e8 cd fd ff ff       	call   80103be0 <mycpu>
  p = c->proc;
80103e13:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e19:	e8 72 09 00 00       	call   80104790 <popcli>
  if((np = allocproc()) == 0){
80103e1e:	e8 7d fc ff ff       	call   80103aa0 <allocproc>
80103e23:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103e26:	85 c0                	test   %eax,%eax
80103e28:	0f 84 b7 00 00 00    	je     80103ee5 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103e2e:	83 ec 08             	sub    $0x8,%esp
80103e31:	ff 33                	push   (%ebx)
80103e33:	89 c7                	mov    %eax,%edi
80103e35:	ff 73 04             	push   0x4(%ebx)
80103e38:	e8 23 34 00 00       	call   80107260 <copyuvm>
80103e3d:	83 c4 10             	add    $0x10,%esp
80103e40:	89 47 04             	mov    %eax,0x4(%edi)
80103e43:	85 c0                	test   %eax,%eax
80103e45:	0f 84 a1 00 00 00    	je     80103eec <fork+0xec>
  np->sz = curproc->sz;
80103e4b:	8b 03                	mov    (%ebx),%eax
80103e4d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103e50:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103e52:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103e55:	89 c8                	mov    %ecx,%eax
80103e57:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103e5a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103e5f:	8b 73 18             	mov    0x18(%ebx),%esi
80103e62:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103e64:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103e66:	8b 40 18             	mov    0x18(%eax),%eax
80103e69:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103e70:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103e74:	85 c0                	test   %eax,%eax
80103e76:	74 13                	je     80103e8b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103e78:	83 ec 0c             	sub    $0xc,%esp
80103e7b:	50                   	push   %eax
80103e7c:	e8 1f d0 ff ff       	call   80100ea0 <filedup>
80103e81:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103e84:	83 c4 10             	add    $0x10,%esp
80103e87:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103e8b:	83 c6 01             	add    $0x1,%esi
80103e8e:	83 fe 10             	cmp    $0x10,%esi
80103e91:	75 dd                	jne    80103e70 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103e93:	83 ec 0c             	sub    $0xc,%esp
80103e96:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e99:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103e9c:	e8 af d8 ff ff       	call   80101750 <idup>
80103ea1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103ea4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103ea7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103eaa:	8d 47 6c             	lea    0x6c(%edi),%eax
80103ead:	6a 10                	push   $0x10
80103eaf:	53                   	push   %ebx
80103eb0:	50                   	push   %eax
80103eb1:	e8 5a 0c 00 00       	call   80104b10 <safestrcpy>
  pid = np->pid;
80103eb6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103eb9:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
80103ec0:	e8 cb 09 00 00       	call   80104890 <acquire>
  np->state = RUNNABLE;
80103ec5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103ecc:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
80103ed3:	e8 58 09 00 00       	call   80104830 <release>
  return pid;
80103ed8:	83 c4 10             	add    $0x10,%esp
}
80103edb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ede:	89 d8                	mov    %ebx,%eax
80103ee0:	5b                   	pop    %ebx
80103ee1:	5e                   	pop    %esi
80103ee2:	5f                   	pop    %edi
80103ee3:	5d                   	pop    %ebp
80103ee4:	c3                   	ret    
    return -1;
80103ee5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103eea:	eb ef                	jmp    80103edb <fork+0xdb>
    kfree(np->kstack);
80103eec:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103eef:	83 ec 0c             	sub    $0xc,%esp
80103ef2:	ff 73 08             	push   0x8(%ebx)
80103ef5:	e8 c6 e5 ff ff       	call   801024c0 <kfree>
    np->kstack = 0;
80103efa:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103f01:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103f04:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103f0b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103f10:	eb c9                	jmp    80103edb <fork+0xdb>
80103f12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103f20 <scheduler>:
{
80103f20:	55                   	push   %ebp
80103f21:	89 e5                	mov    %esp,%ebp
80103f23:	57                   	push   %edi
80103f24:	56                   	push   %esi
80103f25:	53                   	push   %ebx
80103f26:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103f29:	e8 b2 fc ff ff       	call   80103be0 <mycpu>
  c->proc = 0;
80103f2e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103f35:	00 00 00 
  struct cpu *c = mycpu();
80103f38:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103f3a:	8d 78 04             	lea    0x4(%eax),%edi
80103f3d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103f40:	fb                   	sti    
    acquire(&ptable.lock);
80103f41:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f44:	bb 54 ad 14 80       	mov    $0x8014ad54,%ebx
    acquire(&ptable.lock);
80103f49:	68 20 ad 14 80       	push   $0x8014ad20
80103f4e:	e8 3d 09 00 00       	call   80104890 <acquire>
80103f53:	83 c4 10             	add    $0x10,%esp
80103f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f5d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103f60:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103f64:	75 33                	jne    80103f99 <scheduler+0x79>
      switchuvm(p);
80103f66:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103f69:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103f6f:	53                   	push   %ebx
80103f70:	e8 9b 2d 00 00       	call   80106d10 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103f75:	58                   	pop    %eax
80103f76:	5a                   	pop    %edx
80103f77:	ff 73 1c             	push   0x1c(%ebx)
80103f7a:	57                   	push   %edi
      p->state = RUNNING;
80103f7b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103f82:	e8 e4 0b 00 00       	call   80104b6b <swtch>
      switchkvm();
80103f87:	e8 74 2d 00 00       	call   80106d00 <switchkvm>
      c->proc = 0;
80103f8c:	83 c4 10             	add    $0x10,%esp
80103f8f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103f96:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f99:	83 c3 7c             	add    $0x7c,%ebx
80103f9c:	81 fb 54 cc 14 80    	cmp    $0x8014cc54,%ebx
80103fa2:	75 bc                	jne    80103f60 <scheduler+0x40>
    release(&ptable.lock);
80103fa4:	83 ec 0c             	sub    $0xc,%esp
80103fa7:	68 20 ad 14 80       	push   $0x8014ad20
80103fac:	e8 7f 08 00 00       	call   80104830 <release>
    sti();
80103fb1:	83 c4 10             	add    $0x10,%esp
80103fb4:	eb 8a                	jmp    80103f40 <scheduler+0x20>
80103fb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fbd:	8d 76 00             	lea    0x0(%esi),%esi

80103fc0 <sched>:
{
80103fc0:	55                   	push   %ebp
80103fc1:	89 e5                	mov    %esp,%ebp
80103fc3:	56                   	push   %esi
80103fc4:	53                   	push   %ebx
  pushcli();
80103fc5:	e8 76 07 00 00       	call   80104740 <pushcli>
  c = mycpu();
80103fca:	e8 11 fc ff ff       	call   80103be0 <mycpu>
  p = c->proc;
80103fcf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103fd5:	e8 b6 07 00 00       	call   80104790 <popcli>
  if(!holding(&ptable.lock))
80103fda:	83 ec 0c             	sub    $0xc,%esp
80103fdd:	68 20 ad 14 80       	push   $0x8014ad20
80103fe2:	e8 09 08 00 00       	call   801047f0 <holding>
80103fe7:	83 c4 10             	add    $0x10,%esp
80103fea:	85 c0                	test   %eax,%eax
80103fec:	74 4f                	je     8010403d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103fee:	e8 ed fb ff ff       	call   80103be0 <mycpu>
80103ff3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103ffa:	75 68                	jne    80104064 <sched+0xa4>
  if(p->state == RUNNING)
80103ffc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104000:	74 55                	je     80104057 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104002:	9c                   	pushf  
80104003:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104004:	f6 c4 02             	test   $0x2,%ah
80104007:	75 41                	jne    8010404a <sched+0x8a>
  intena = mycpu()->intena;
80104009:	e8 d2 fb ff ff       	call   80103be0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010400e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104011:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104017:	e8 c4 fb ff ff       	call   80103be0 <mycpu>
8010401c:	83 ec 08             	sub    $0x8,%esp
8010401f:	ff 70 04             	push   0x4(%eax)
80104022:	53                   	push   %ebx
80104023:	e8 43 0b 00 00       	call   80104b6b <swtch>
  mycpu()->intena = intena;
80104028:	e8 b3 fb ff ff       	call   80103be0 <mycpu>
}
8010402d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104030:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104036:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104039:	5b                   	pop    %ebx
8010403a:	5e                   	pop    %esi
8010403b:	5d                   	pop    %ebp
8010403c:	c3                   	ret    
    panic("sched ptable.lock");
8010403d:	83 ec 0c             	sub    $0xc,%esp
80104040:	68 5b 7c 10 80       	push   $0x80107c5b
80104045:	e8 36 c3 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
8010404a:	83 ec 0c             	sub    $0xc,%esp
8010404d:	68 87 7c 10 80       	push   $0x80107c87
80104052:	e8 29 c3 ff ff       	call   80100380 <panic>
    panic("sched running");
80104057:	83 ec 0c             	sub    $0xc,%esp
8010405a:	68 79 7c 10 80       	push   $0x80107c79
8010405f:	e8 1c c3 ff ff       	call   80100380 <panic>
    panic("sched locks");
80104064:	83 ec 0c             	sub    $0xc,%esp
80104067:	68 6d 7c 10 80       	push   $0x80107c6d
8010406c:	e8 0f c3 ff ff       	call   80100380 <panic>
80104071:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104078:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010407f:	90                   	nop

80104080 <exit>:
{
80104080:	55                   	push   %ebp
80104081:	89 e5                	mov    %esp,%ebp
80104083:	57                   	push   %edi
80104084:	56                   	push   %esi
80104085:	53                   	push   %ebx
80104086:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80104089:	e8 d2 fb ff ff       	call   80103c60 <myproc>
  if(curproc == initproc)
8010408e:	39 05 54 cc 14 80    	cmp    %eax,0x8014cc54
80104094:	0f 84 fd 00 00 00    	je     80104197 <exit+0x117>
8010409a:	89 c3                	mov    %eax,%ebx
8010409c:	8d 70 28             	lea    0x28(%eax),%esi
8010409f:	8d 78 68             	lea    0x68(%eax),%edi
801040a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
801040a8:	8b 06                	mov    (%esi),%eax
801040aa:	85 c0                	test   %eax,%eax
801040ac:	74 12                	je     801040c0 <exit+0x40>
      fileclose(curproc->ofile[fd]);
801040ae:	83 ec 0c             	sub    $0xc,%esp
801040b1:	50                   	push   %eax
801040b2:	e8 39 ce ff ff       	call   80100ef0 <fileclose>
      curproc->ofile[fd] = 0;
801040b7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801040bd:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
801040c0:	83 c6 04             	add    $0x4,%esi
801040c3:	39 f7                	cmp    %esi,%edi
801040c5:	75 e1                	jne    801040a8 <exit+0x28>
  begin_op();
801040c7:	e8 84 ef ff ff       	call   80103050 <begin_op>
  iput(curproc->cwd);
801040cc:	83 ec 0c             	sub    $0xc,%esp
801040cf:	ff 73 68             	push   0x68(%ebx)
801040d2:	e8 d9 d7 ff ff       	call   801018b0 <iput>
  end_op();
801040d7:	e8 e4 ef ff ff       	call   801030c0 <end_op>
  curproc->cwd = 0;
801040dc:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
801040e3:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
801040ea:	e8 a1 07 00 00       	call   80104890 <acquire>
  wakeup1(curproc->parent);
801040ef:	8b 53 14             	mov    0x14(%ebx),%edx
801040f2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040f5:	b8 54 ad 14 80       	mov    $0x8014ad54,%eax
801040fa:	eb 0e                	jmp    8010410a <exit+0x8a>
801040fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104100:	83 c0 7c             	add    $0x7c,%eax
80104103:	3d 54 cc 14 80       	cmp    $0x8014cc54,%eax
80104108:	74 1c                	je     80104126 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
8010410a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010410e:	75 f0                	jne    80104100 <exit+0x80>
80104110:	3b 50 20             	cmp    0x20(%eax),%edx
80104113:	75 eb                	jne    80104100 <exit+0x80>
      p->state = RUNNABLE;
80104115:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010411c:	83 c0 7c             	add    $0x7c,%eax
8010411f:	3d 54 cc 14 80       	cmp    $0x8014cc54,%eax
80104124:	75 e4                	jne    8010410a <exit+0x8a>
      p->parent = initproc;
80104126:	8b 0d 54 cc 14 80    	mov    0x8014cc54,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010412c:	ba 54 ad 14 80       	mov    $0x8014ad54,%edx
80104131:	eb 10                	jmp    80104143 <exit+0xc3>
80104133:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104137:	90                   	nop
80104138:	83 c2 7c             	add    $0x7c,%edx
8010413b:	81 fa 54 cc 14 80    	cmp    $0x8014cc54,%edx
80104141:	74 3b                	je     8010417e <exit+0xfe>
    if(p->parent == curproc){
80104143:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104146:	75 f0                	jne    80104138 <exit+0xb8>
      if(p->state == ZOMBIE)
80104148:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
8010414c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010414f:	75 e7                	jne    80104138 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104151:	b8 54 ad 14 80       	mov    $0x8014ad54,%eax
80104156:	eb 12                	jmp    8010416a <exit+0xea>
80104158:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010415f:	90                   	nop
80104160:	83 c0 7c             	add    $0x7c,%eax
80104163:	3d 54 cc 14 80       	cmp    $0x8014cc54,%eax
80104168:	74 ce                	je     80104138 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
8010416a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010416e:	75 f0                	jne    80104160 <exit+0xe0>
80104170:	3b 48 20             	cmp    0x20(%eax),%ecx
80104173:	75 eb                	jne    80104160 <exit+0xe0>
      p->state = RUNNABLE;
80104175:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010417c:	eb e2                	jmp    80104160 <exit+0xe0>
  curproc->state = ZOMBIE;
8010417e:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80104185:	e8 36 fe ff ff       	call   80103fc0 <sched>
  panic("zombie exit");
8010418a:	83 ec 0c             	sub    $0xc,%esp
8010418d:	68 a8 7c 10 80       	push   $0x80107ca8
80104192:	e8 e9 c1 ff ff       	call   80100380 <panic>
    panic("init exiting");
80104197:	83 ec 0c             	sub    $0xc,%esp
8010419a:	68 9b 7c 10 80       	push   $0x80107c9b
8010419f:	e8 dc c1 ff ff       	call   80100380 <panic>
801041a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041af:	90                   	nop

801041b0 <wait>:
{
801041b0:	55                   	push   %ebp
801041b1:	89 e5                	mov    %esp,%ebp
801041b3:	56                   	push   %esi
801041b4:	53                   	push   %ebx
  pushcli();
801041b5:	e8 86 05 00 00       	call   80104740 <pushcli>
  c = mycpu();
801041ba:	e8 21 fa ff ff       	call   80103be0 <mycpu>
  p = c->proc;
801041bf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801041c5:	e8 c6 05 00 00       	call   80104790 <popcli>
  acquire(&ptable.lock);
801041ca:	83 ec 0c             	sub    $0xc,%esp
801041cd:	68 20 ad 14 80       	push   $0x8014ad20
801041d2:	e8 b9 06 00 00       	call   80104890 <acquire>
801041d7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801041da:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041dc:	bb 54 ad 14 80       	mov    $0x8014ad54,%ebx
801041e1:	eb 10                	jmp    801041f3 <wait+0x43>
801041e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041e7:	90                   	nop
801041e8:	83 c3 7c             	add    $0x7c,%ebx
801041eb:	81 fb 54 cc 14 80    	cmp    $0x8014cc54,%ebx
801041f1:	74 1b                	je     8010420e <wait+0x5e>
      if(p->parent != curproc)
801041f3:	39 73 14             	cmp    %esi,0x14(%ebx)
801041f6:	75 f0                	jne    801041e8 <wait+0x38>
      if(p->state == ZOMBIE){
801041f8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801041fc:	74 62                	je     80104260 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041fe:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80104201:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104206:	81 fb 54 cc 14 80    	cmp    $0x8014cc54,%ebx
8010420c:	75 e5                	jne    801041f3 <wait+0x43>
    if(!havekids || curproc->killed){
8010420e:	85 c0                	test   %eax,%eax
80104210:	0f 84 a0 00 00 00    	je     801042b6 <wait+0x106>
80104216:	8b 46 24             	mov    0x24(%esi),%eax
80104219:	85 c0                	test   %eax,%eax
8010421b:	0f 85 95 00 00 00    	jne    801042b6 <wait+0x106>
  pushcli();
80104221:	e8 1a 05 00 00       	call   80104740 <pushcli>
  c = mycpu();
80104226:	e8 b5 f9 ff ff       	call   80103be0 <mycpu>
  p = c->proc;
8010422b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104231:	e8 5a 05 00 00       	call   80104790 <popcli>
  if(p == 0)
80104236:	85 db                	test   %ebx,%ebx
80104238:	0f 84 8f 00 00 00    	je     801042cd <wait+0x11d>
  p->chan = chan;
8010423e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104241:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104248:	e8 73 fd ff ff       	call   80103fc0 <sched>
  p->chan = 0;
8010424d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104254:	eb 84                	jmp    801041da <wait+0x2a>
80104256:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010425d:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104260:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104263:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104266:	ff 73 08             	push   0x8(%ebx)
80104269:	e8 52 e2 ff ff       	call   801024c0 <kfree>
        p->kstack = 0;
8010426e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104275:	5a                   	pop    %edx
80104276:	ff 73 04             	push   0x4(%ebx)
80104279:	e8 72 2e 00 00       	call   801070f0 <freevm>
        p->pid = 0;
8010427e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104285:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010428c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104290:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104297:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010429e:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
801042a5:	e8 86 05 00 00       	call   80104830 <release>
        return pid;
801042aa:	83 c4 10             	add    $0x10,%esp
}
801042ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042b0:	89 f0                	mov    %esi,%eax
801042b2:	5b                   	pop    %ebx
801042b3:	5e                   	pop    %esi
801042b4:	5d                   	pop    %ebp
801042b5:	c3                   	ret    
      release(&ptable.lock);
801042b6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801042b9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801042be:	68 20 ad 14 80       	push   $0x8014ad20
801042c3:	e8 68 05 00 00       	call   80104830 <release>
      return -1;
801042c8:	83 c4 10             	add    $0x10,%esp
801042cb:	eb e0                	jmp    801042ad <wait+0xfd>
    panic("sleep");
801042cd:	83 ec 0c             	sub    $0xc,%esp
801042d0:	68 b4 7c 10 80       	push   $0x80107cb4
801042d5:	e8 a6 c0 ff ff       	call   80100380 <panic>
801042da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801042e0 <yield>:
{
801042e0:	55                   	push   %ebp
801042e1:	89 e5                	mov    %esp,%ebp
801042e3:	53                   	push   %ebx
801042e4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801042e7:	68 20 ad 14 80       	push   $0x8014ad20
801042ec:	e8 9f 05 00 00       	call   80104890 <acquire>
  pushcli();
801042f1:	e8 4a 04 00 00       	call   80104740 <pushcli>
  c = mycpu();
801042f6:	e8 e5 f8 ff ff       	call   80103be0 <mycpu>
  p = c->proc;
801042fb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104301:	e8 8a 04 00 00       	call   80104790 <popcli>
  myproc()->state = RUNNABLE;
80104306:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010430d:	e8 ae fc ff ff       	call   80103fc0 <sched>
  release(&ptable.lock);
80104312:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
80104319:	e8 12 05 00 00       	call   80104830 <release>
}
8010431e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104321:	83 c4 10             	add    $0x10,%esp
80104324:	c9                   	leave  
80104325:	c3                   	ret    
80104326:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010432d:	8d 76 00             	lea    0x0(%esi),%esi

80104330 <sleep>:
{
80104330:	55                   	push   %ebp
80104331:	89 e5                	mov    %esp,%ebp
80104333:	57                   	push   %edi
80104334:	56                   	push   %esi
80104335:	53                   	push   %ebx
80104336:	83 ec 0c             	sub    $0xc,%esp
80104339:	8b 7d 08             	mov    0x8(%ebp),%edi
8010433c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010433f:	e8 fc 03 00 00       	call   80104740 <pushcli>
  c = mycpu();
80104344:	e8 97 f8 ff ff       	call   80103be0 <mycpu>
  p = c->proc;
80104349:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010434f:	e8 3c 04 00 00       	call   80104790 <popcli>
  if(p == 0)
80104354:	85 db                	test   %ebx,%ebx
80104356:	0f 84 87 00 00 00    	je     801043e3 <sleep+0xb3>
  if(lk == 0)
8010435c:	85 f6                	test   %esi,%esi
8010435e:	74 76                	je     801043d6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104360:	81 fe 20 ad 14 80    	cmp    $0x8014ad20,%esi
80104366:	74 50                	je     801043b8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104368:	83 ec 0c             	sub    $0xc,%esp
8010436b:	68 20 ad 14 80       	push   $0x8014ad20
80104370:	e8 1b 05 00 00       	call   80104890 <acquire>
    release(lk);
80104375:	89 34 24             	mov    %esi,(%esp)
80104378:	e8 b3 04 00 00       	call   80104830 <release>
  p->chan = chan;
8010437d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104380:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104387:	e8 34 fc ff ff       	call   80103fc0 <sched>
  p->chan = 0;
8010438c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104393:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
8010439a:	e8 91 04 00 00       	call   80104830 <release>
    acquire(lk);
8010439f:	89 75 08             	mov    %esi,0x8(%ebp)
801043a2:	83 c4 10             	add    $0x10,%esp
}
801043a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043a8:	5b                   	pop    %ebx
801043a9:	5e                   	pop    %esi
801043aa:	5f                   	pop    %edi
801043ab:	5d                   	pop    %ebp
    acquire(lk);
801043ac:	e9 df 04 00 00       	jmp    80104890 <acquire>
801043b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801043b8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801043bb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801043c2:	e8 f9 fb ff ff       	call   80103fc0 <sched>
  p->chan = 0;
801043c7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801043ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043d1:	5b                   	pop    %ebx
801043d2:	5e                   	pop    %esi
801043d3:	5f                   	pop    %edi
801043d4:	5d                   	pop    %ebp
801043d5:	c3                   	ret    
    panic("sleep without lk");
801043d6:	83 ec 0c             	sub    $0xc,%esp
801043d9:	68 ba 7c 10 80       	push   $0x80107cba
801043de:	e8 9d bf ff ff       	call   80100380 <panic>
    panic("sleep");
801043e3:	83 ec 0c             	sub    $0xc,%esp
801043e6:	68 b4 7c 10 80       	push   $0x80107cb4
801043eb:	e8 90 bf ff ff       	call   80100380 <panic>

801043f0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
801043f3:	53                   	push   %ebx
801043f4:	83 ec 10             	sub    $0x10,%esp
801043f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801043fa:	68 20 ad 14 80       	push   $0x8014ad20
801043ff:	e8 8c 04 00 00       	call   80104890 <acquire>
80104404:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104407:	b8 54 ad 14 80       	mov    $0x8014ad54,%eax
8010440c:	eb 0c                	jmp    8010441a <wakeup+0x2a>
8010440e:	66 90                	xchg   %ax,%ax
80104410:	83 c0 7c             	add    $0x7c,%eax
80104413:	3d 54 cc 14 80       	cmp    $0x8014cc54,%eax
80104418:	74 1c                	je     80104436 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010441a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010441e:	75 f0                	jne    80104410 <wakeup+0x20>
80104420:	3b 58 20             	cmp    0x20(%eax),%ebx
80104423:	75 eb                	jne    80104410 <wakeup+0x20>
      p->state = RUNNABLE;
80104425:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010442c:	83 c0 7c             	add    $0x7c,%eax
8010442f:	3d 54 cc 14 80       	cmp    $0x8014cc54,%eax
80104434:	75 e4                	jne    8010441a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104436:	c7 45 08 20 ad 14 80 	movl   $0x8014ad20,0x8(%ebp)
}
8010443d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104440:	c9                   	leave  
  release(&ptable.lock);
80104441:	e9 ea 03 00 00       	jmp    80104830 <release>
80104446:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010444d:	8d 76 00             	lea    0x0(%esi),%esi

80104450 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104450:	55                   	push   %ebp
80104451:	89 e5                	mov    %esp,%ebp
80104453:	53                   	push   %ebx
80104454:	83 ec 10             	sub    $0x10,%esp
80104457:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010445a:	68 20 ad 14 80       	push   $0x8014ad20
8010445f:	e8 2c 04 00 00       	call   80104890 <acquire>
80104464:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104467:	b8 54 ad 14 80       	mov    $0x8014ad54,%eax
8010446c:	eb 0c                	jmp    8010447a <kill+0x2a>
8010446e:	66 90                	xchg   %ax,%ax
80104470:	83 c0 7c             	add    $0x7c,%eax
80104473:	3d 54 cc 14 80       	cmp    $0x8014cc54,%eax
80104478:	74 36                	je     801044b0 <kill+0x60>
    if(p->pid == pid){
8010447a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010447d:	75 f1                	jne    80104470 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010447f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104483:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010448a:	75 07                	jne    80104493 <kill+0x43>
        p->state = RUNNABLE;
8010448c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104493:	83 ec 0c             	sub    $0xc,%esp
80104496:	68 20 ad 14 80       	push   $0x8014ad20
8010449b:	e8 90 03 00 00       	call   80104830 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801044a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801044a3:	83 c4 10             	add    $0x10,%esp
801044a6:	31 c0                	xor    %eax,%eax
}
801044a8:	c9                   	leave  
801044a9:	c3                   	ret    
801044aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801044b0:	83 ec 0c             	sub    $0xc,%esp
801044b3:	68 20 ad 14 80       	push   $0x8014ad20
801044b8:	e8 73 03 00 00       	call   80104830 <release>
}
801044bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801044c0:	83 c4 10             	add    $0x10,%esp
801044c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801044c8:	c9                   	leave  
801044c9:	c3                   	ret    
801044ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044d0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801044d0:	55                   	push   %ebp
801044d1:	89 e5                	mov    %esp,%ebp
801044d3:	57                   	push   %edi
801044d4:	56                   	push   %esi
801044d5:	8d 75 e8             	lea    -0x18(%ebp),%esi
801044d8:	53                   	push   %ebx
801044d9:	bb c0 ad 14 80       	mov    $0x8014adc0,%ebx
801044de:	83 ec 3c             	sub    $0x3c,%esp
801044e1:	eb 24                	jmp    80104507 <procdump+0x37>
801044e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044e7:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801044e8:	83 ec 0c             	sub    $0xc,%esp
801044eb:	68 8f 80 10 80       	push   $0x8010808f
801044f0:	e8 ab c1 ff ff       	call   801006a0 <cprintf>
801044f5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044f8:	83 c3 7c             	add    $0x7c,%ebx
801044fb:	81 fb c0 cc 14 80    	cmp    $0x8014ccc0,%ebx
80104501:	0f 84 81 00 00 00    	je     80104588 <procdump+0xb8>
    if(p->state == UNUSED)
80104507:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010450a:	85 c0                	test   %eax,%eax
8010450c:	74 ea                	je     801044f8 <procdump+0x28>
      state = "???";
8010450e:	ba cb 7c 10 80       	mov    $0x80107ccb,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104513:	83 f8 05             	cmp    $0x5,%eax
80104516:	77 11                	ja     80104529 <procdump+0x59>
80104518:	8b 14 85 2c 7d 10 80 	mov    -0x7fef82d4(,%eax,4),%edx
      state = "???";
8010451f:	b8 cb 7c 10 80       	mov    $0x80107ccb,%eax
80104524:	85 d2                	test   %edx,%edx
80104526:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104529:	53                   	push   %ebx
8010452a:	52                   	push   %edx
8010452b:	ff 73 a4             	push   -0x5c(%ebx)
8010452e:	68 cf 7c 10 80       	push   $0x80107ccf
80104533:	e8 68 c1 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
80104538:	83 c4 10             	add    $0x10,%esp
8010453b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010453f:	75 a7                	jne    801044e8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104541:	83 ec 08             	sub    $0x8,%esp
80104544:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104547:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010454a:	50                   	push   %eax
8010454b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010454e:	8b 40 0c             	mov    0xc(%eax),%eax
80104551:	83 c0 08             	add    $0x8,%eax
80104554:	50                   	push   %eax
80104555:	e8 86 01 00 00       	call   801046e0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010455a:	83 c4 10             	add    $0x10,%esp
8010455d:	8d 76 00             	lea    0x0(%esi),%esi
80104560:	8b 17                	mov    (%edi),%edx
80104562:	85 d2                	test   %edx,%edx
80104564:	74 82                	je     801044e8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104566:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104569:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010456c:	52                   	push   %edx
8010456d:	68 01 77 10 80       	push   $0x80107701
80104572:	e8 29 c1 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104577:	83 c4 10             	add    $0x10,%esp
8010457a:	39 fe                	cmp    %edi,%esi
8010457c:	75 e2                	jne    80104560 <procdump+0x90>
8010457e:	e9 65 ff ff ff       	jmp    801044e8 <procdump+0x18>
80104583:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104587:	90                   	nop
  }
}
80104588:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010458b:	5b                   	pop    %ebx
8010458c:	5e                   	pop    %esi
8010458d:	5f                   	pop    %edi
8010458e:	5d                   	pop    %ebp
8010458f:	c3                   	ret    

80104590 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	53                   	push   %ebx
80104594:	83 ec 0c             	sub    $0xc,%esp
80104597:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010459a:	68 44 7d 10 80       	push   $0x80107d44
8010459f:	8d 43 04             	lea    0x4(%ebx),%eax
801045a2:	50                   	push   %eax
801045a3:	e8 18 01 00 00       	call   801046c0 <initlock>
  lk->name = name;
801045a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801045ab:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801045b1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801045b4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801045bb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801045be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045c1:	c9                   	leave  
801045c2:	c3                   	ret    
801045c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045d0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	56                   	push   %esi
801045d4:	53                   	push   %ebx
801045d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801045d8:	8d 73 04             	lea    0x4(%ebx),%esi
801045db:	83 ec 0c             	sub    $0xc,%esp
801045de:	56                   	push   %esi
801045df:	e8 ac 02 00 00       	call   80104890 <acquire>
  while (lk->locked) {
801045e4:	8b 13                	mov    (%ebx),%edx
801045e6:	83 c4 10             	add    $0x10,%esp
801045e9:	85 d2                	test   %edx,%edx
801045eb:	74 16                	je     80104603 <acquiresleep+0x33>
801045ed:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801045f0:	83 ec 08             	sub    $0x8,%esp
801045f3:	56                   	push   %esi
801045f4:	53                   	push   %ebx
801045f5:	e8 36 fd ff ff       	call   80104330 <sleep>
  while (lk->locked) {
801045fa:	8b 03                	mov    (%ebx),%eax
801045fc:	83 c4 10             	add    $0x10,%esp
801045ff:	85 c0                	test   %eax,%eax
80104601:	75 ed                	jne    801045f0 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104603:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104609:	e8 52 f6 ff ff       	call   80103c60 <myproc>
8010460e:	8b 40 10             	mov    0x10(%eax),%eax
80104611:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104614:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104617:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010461a:	5b                   	pop    %ebx
8010461b:	5e                   	pop    %esi
8010461c:	5d                   	pop    %ebp
  release(&lk->lk);
8010461d:	e9 0e 02 00 00       	jmp    80104830 <release>
80104622:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104630 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104630:	55                   	push   %ebp
80104631:	89 e5                	mov    %esp,%ebp
80104633:	56                   	push   %esi
80104634:	53                   	push   %ebx
80104635:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104638:	8d 73 04             	lea    0x4(%ebx),%esi
8010463b:	83 ec 0c             	sub    $0xc,%esp
8010463e:	56                   	push   %esi
8010463f:	e8 4c 02 00 00       	call   80104890 <acquire>
  lk->locked = 0;
80104644:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010464a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104651:	89 1c 24             	mov    %ebx,(%esp)
80104654:	e8 97 fd ff ff       	call   801043f0 <wakeup>
  release(&lk->lk);
80104659:	89 75 08             	mov    %esi,0x8(%ebp)
8010465c:	83 c4 10             	add    $0x10,%esp
}
8010465f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104662:	5b                   	pop    %ebx
80104663:	5e                   	pop    %esi
80104664:	5d                   	pop    %ebp
  release(&lk->lk);
80104665:	e9 c6 01 00 00       	jmp    80104830 <release>
8010466a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104670 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	57                   	push   %edi
80104674:	31 ff                	xor    %edi,%edi
80104676:	56                   	push   %esi
80104677:	53                   	push   %ebx
80104678:	83 ec 18             	sub    $0x18,%esp
8010467b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010467e:	8d 73 04             	lea    0x4(%ebx),%esi
80104681:	56                   	push   %esi
80104682:	e8 09 02 00 00       	call   80104890 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104687:	8b 03                	mov    (%ebx),%eax
80104689:	83 c4 10             	add    $0x10,%esp
8010468c:	85 c0                	test   %eax,%eax
8010468e:	75 18                	jne    801046a8 <holdingsleep+0x38>
  release(&lk->lk);
80104690:	83 ec 0c             	sub    $0xc,%esp
80104693:	56                   	push   %esi
80104694:	e8 97 01 00 00       	call   80104830 <release>
  return r;
}
80104699:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010469c:	89 f8                	mov    %edi,%eax
8010469e:	5b                   	pop    %ebx
8010469f:	5e                   	pop    %esi
801046a0:	5f                   	pop    %edi
801046a1:	5d                   	pop    %ebp
801046a2:	c3                   	ret    
801046a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046a7:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
801046a8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801046ab:	e8 b0 f5 ff ff       	call   80103c60 <myproc>
801046b0:	39 58 10             	cmp    %ebx,0x10(%eax)
801046b3:	0f 94 c0             	sete   %al
801046b6:	0f b6 c0             	movzbl %al,%eax
801046b9:	89 c7                	mov    %eax,%edi
801046bb:	eb d3                	jmp    80104690 <holdingsleep+0x20>
801046bd:	66 90                	xchg   %ax,%ax
801046bf:	90                   	nop

801046c0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801046c0:	55                   	push   %ebp
801046c1:	89 e5                	mov    %esp,%ebp
801046c3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801046c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801046c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801046cf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801046d2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801046d9:	5d                   	pop    %ebp
801046da:	c3                   	ret    
801046db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046df:	90                   	nop

801046e0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801046e0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801046e1:	31 d2                	xor    %edx,%edx
{
801046e3:	89 e5                	mov    %esp,%ebp
801046e5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801046e6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801046e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801046ec:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
801046ef:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801046f0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801046f6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801046fc:	77 1a                	ja     80104718 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801046fe:	8b 58 04             	mov    0x4(%eax),%ebx
80104701:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104704:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104707:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104709:	83 fa 0a             	cmp    $0xa,%edx
8010470c:	75 e2                	jne    801046f0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010470e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104711:	c9                   	leave  
80104712:	c3                   	ret    
80104713:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104717:	90                   	nop
  for(; i < 10; i++)
80104718:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010471b:	8d 51 28             	lea    0x28(%ecx),%edx
8010471e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104720:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104726:	83 c0 04             	add    $0x4,%eax
80104729:	39 d0                	cmp    %edx,%eax
8010472b:	75 f3                	jne    80104720 <getcallerpcs+0x40>
}
8010472d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104730:	c9                   	leave  
80104731:	c3                   	ret    
80104732:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104740 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104740:	55                   	push   %ebp
80104741:	89 e5                	mov    %esp,%ebp
80104743:	53                   	push   %ebx
80104744:	83 ec 04             	sub    $0x4,%esp
80104747:	9c                   	pushf  
80104748:	5b                   	pop    %ebx
  asm volatile("cli");
80104749:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010474a:	e8 91 f4 ff ff       	call   80103be0 <mycpu>
8010474f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104755:	85 c0                	test   %eax,%eax
80104757:	74 17                	je     80104770 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104759:	e8 82 f4 ff ff       	call   80103be0 <mycpu>
8010475e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104765:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104768:	c9                   	leave  
80104769:	c3                   	ret    
8010476a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104770:	e8 6b f4 ff ff       	call   80103be0 <mycpu>
80104775:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010477b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104781:	eb d6                	jmp    80104759 <pushcli+0x19>
80104783:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010478a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104790 <popcli>:

void
popcli(void)
{
80104790:	55                   	push   %ebp
80104791:	89 e5                	mov    %esp,%ebp
80104793:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104796:	9c                   	pushf  
80104797:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104798:	f6 c4 02             	test   $0x2,%ah
8010479b:	75 35                	jne    801047d2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010479d:	e8 3e f4 ff ff       	call   80103be0 <mycpu>
801047a2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801047a9:	78 34                	js     801047df <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801047ab:	e8 30 f4 ff ff       	call   80103be0 <mycpu>
801047b0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801047b6:	85 d2                	test   %edx,%edx
801047b8:	74 06                	je     801047c0 <popcli+0x30>
    sti();
}
801047ba:	c9                   	leave  
801047bb:	c3                   	ret    
801047bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801047c0:	e8 1b f4 ff ff       	call   80103be0 <mycpu>
801047c5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801047cb:	85 c0                	test   %eax,%eax
801047cd:	74 eb                	je     801047ba <popcli+0x2a>
  asm volatile("sti");
801047cf:	fb                   	sti    
}
801047d0:	c9                   	leave  
801047d1:	c3                   	ret    
    panic("popcli - interruptible");
801047d2:	83 ec 0c             	sub    $0xc,%esp
801047d5:	68 4f 7d 10 80       	push   $0x80107d4f
801047da:	e8 a1 bb ff ff       	call   80100380 <panic>
    panic("popcli");
801047df:	83 ec 0c             	sub    $0xc,%esp
801047e2:	68 66 7d 10 80       	push   $0x80107d66
801047e7:	e8 94 bb ff ff       	call   80100380 <panic>
801047ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047f0 <holding>:
{
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	56                   	push   %esi
801047f4:	53                   	push   %ebx
801047f5:	8b 75 08             	mov    0x8(%ebp),%esi
801047f8:	31 db                	xor    %ebx,%ebx
  pushcli();
801047fa:	e8 41 ff ff ff       	call   80104740 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801047ff:	8b 06                	mov    (%esi),%eax
80104801:	85 c0                	test   %eax,%eax
80104803:	75 0b                	jne    80104810 <holding+0x20>
  popcli();
80104805:	e8 86 ff ff ff       	call   80104790 <popcli>
}
8010480a:	89 d8                	mov    %ebx,%eax
8010480c:	5b                   	pop    %ebx
8010480d:	5e                   	pop    %esi
8010480e:	5d                   	pop    %ebp
8010480f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104810:	8b 5e 08             	mov    0x8(%esi),%ebx
80104813:	e8 c8 f3 ff ff       	call   80103be0 <mycpu>
80104818:	39 c3                	cmp    %eax,%ebx
8010481a:	0f 94 c3             	sete   %bl
  popcli();
8010481d:	e8 6e ff ff ff       	call   80104790 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104822:	0f b6 db             	movzbl %bl,%ebx
}
80104825:	89 d8                	mov    %ebx,%eax
80104827:	5b                   	pop    %ebx
80104828:	5e                   	pop    %esi
80104829:	5d                   	pop    %ebp
8010482a:	c3                   	ret    
8010482b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010482f:	90                   	nop

80104830 <release>:
{
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	56                   	push   %esi
80104834:	53                   	push   %ebx
80104835:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104838:	e8 03 ff ff ff       	call   80104740 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010483d:	8b 03                	mov    (%ebx),%eax
8010483f:	85 c0                	test   %eax,%eax
80104841:	75 15                	jne    80104858 <release+0x28>
  popcli();
80104843:	e8 48 ff ff ff       	call   80104790 <popcli>
    panic("release");
80104848:	83 ec 0c             	sub    $0xc,%esp
8010484b:	68 6d 7d 10 80       	push   $0x80107d6d
80104850:	e8 2b bb ff ff       	call   80100380 <panic>
80104855:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104858:	8b 73 08             	mov    0x8(%ebx),%esi
8010485b:	e8 80 f3 ff ff       	call   80103be0 <mycpu>
80104860:	39 c6                	cmp    %eax,%esi
80104862:	75 df                	jne    80104843 <release+0x13>
  popcli();
80104864:	e8 27 ff ff ff       	call   80104790 <popcli>
  lk->pcs[0] = 0;
80104869:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104870:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104877:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010487c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104882:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104885:	5b                   	pop    %ebx
80104886:	5e                   	pop    %esi
80104887:	5d                   	pop    %ebp
  popcli();
80104888:	e9 03 ff ff ff       	jmp    80104790 <popcli>
8010488d:	8d 76 00             	lea    0x0(%esi),%esi

80104890 <acquire>:
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	53                   	push   %ebx
80104894:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104897:	e8 a4 fe ff ff       	call   80104740 <pushcli>
  if(holding(lk))
8010489c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010489f:	e8 9c fe ff ff       	call   80104740 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801048a4:	8b 03                	mov    (%ebx),%eax
801048a6:	85 c0                	test   %eax,%eax
801048a8:	75 7e                	jne    80104928 <acquire+0x98>
  popcli();
801048aa:	e8 e1 fe ff ff       	call   80104790 <popcli>
  asm volatile("lock; xchgl %0, %1" :
801048af:	b9 01 00 00 00       	mov    $0x1,%ecx
801048b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
801048b8:	8b 55 08             	mov    0x8(%ebp),%edx
801048bb:	89 c8                	mov    %ecx,%eax
801048bd:	f0 87 02             	lock xchg %eax,(%edx)
801048c0:	85 c0                	test   %eax,%eax
801048c2:	75 f4                	jne    801048b8 <acquire+0x28>
  __sync_synchronize();
801048c4:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801048c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801048cc:	e8 0f f3 ff ff       	call   80103be0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801048d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
801048d4:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
801048d6:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
801048d9:	31 c0                	xor    %eax,%eax
801048db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048df:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801048e0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801048e6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801048ec:	77 1a                	ja     80104908 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
801048ee:	8b 5a 04             	mov    0x4(%edx),%ebx
801048f1:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801048f5:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801048f8:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801048fa:	83 f8 0a             	cmp    $0xa,%eax
801048fd:	75 e1                	jne    801048e0 <acquire+0x50>
}
801048ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104902:	c9                   	leave  
80104903:	c3                   	ret    
80104904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104908:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
8010490c:	8d 51 34             	lea    0x34(%ecx),%edx
8010490f:	90                   	nop
    pcs[i] = 0;
80104910:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104916:	83 c0 04             	add    $0x4,%eax
80104919:	39 c2                	cmp    %eax,%edx
8010491b:	75 f3                	jne    80104910 <acquire+0x80>
}
8010491d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104920:	c9                   	leave  
80104921:	c3                   	ret    
80104922:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104928:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010492b:	e8 b0 f2 ff ff       	call   80103be0 <mycpu>
80104930:	39 c3                	cmp    %eax,%ebx
80104932:	0f 85 72 ff ff ff    	jne    801048aa <acquire+0x1a>
  popcli();
80104938:	e8 53 fe ff ff       	call   80104790 <popcli>
    panic("acquire");
8010493d:	83 ec 0c             	sub    $0xc,%esp
80104940:	68 75 7d 10 80       	push   $0x80107d75
80104945:	e8 36 ba ff ff       	call   80100380 <panic>
8010494a:	66 90                	xchg   %ax,%ax
8010494c:	66 90                	xchg   %ax,%ax
8010494e:	66 90                	xchg   %ax,%ax

80104950 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	57                   	push   %edi
80104954:	8b 55 08             	mov    0x8(%ebp),%edx
80104957:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010495a:	53                   	push   %ebx
8010495b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
8010495e:	89 d7                	mov    %edx,%edi
80104960:	09 cf                	or     %ecx,%edi
80104962:	83 e7 03             	and    $0x3,%edi
80104965:	75 29                	jne    80104990 <memset+0x40>
    c &= 0xFF;
80104967:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010496a:	c1 e0 18             	shl    $0x18,%eax
8010496d:	89 fb                	mov    %edi,%ebx
8010496f:	c1 e9 02             	shr    $0x2,%ecx
80104972:	c1 e3 10             	shl    $0x10,%ebx
80104975:	09 d8                	or     %ebx,%eax
80104977:	09 f8                	or     %edi,%eax
80104979:	c1 e7 08             	shl    $0x8,%edi
8010497c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
8010497e:	89 d7                	mov    %edx,%edi
80104980:	fc                   	cld    
80104981:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104983:	5b                   	pop    %ebx
80104984:	89 d0                	mov    %edx,%eax
80104986:	5f                   	pop    %edi
80104987:	5d                   	pop    %ebp
80104988:	c3                   	ret    
80104989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104990:	89 d7                	mov    %edx,%edi
80104992:	fc                   	cld    
80104993:	f3 aa                	rep stos %al,%es:(%edi)
80104995:	5b                   	pop    %ebx
80104996:	89 d0                	mov    %edx,%eax
80104998:	5f                   	pop    %edi
80104999:	5d                   	pop    %ebp
8010499a:	c3                   	ret    
8010499b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010499f:	90                   	nop

801049a0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801049a0:	55                   	push   %ebp
801049a1:	89 e5                	mov    %esp,%ebp
801049a3:	56                   	push   %esi
801049a4:	8b 75 10             	mov    0x10(%ebp),%esi
801049a7:	8b 55 08             	mov    0x8(%ebp),%edx
801049aa:	53                   	push   %ebx
801049ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801049ae:	85 f6                	test   %esi,%esi
801049b0:	74 2e                	je     801049e0 <memcmp+0x40>
801049b2:	01 c6                	add    %eax,%esi
801049b4:	eb 14                	jmp    801049ca <memcmp+0x2a>
801049b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049bd:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801049c0:	83 c0 01             	add    $0x1,%eax
801049c3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801049c6:	39 f0                	cmp    %esi,%eax
801049c8:	74 16                	je     801049e0 <memcmp+0x40>
    if(*s1 != *s2)
801049ca:	0f b6 0a             	movzbl (%edx),%ecx
801049cd:	0f b6 18             	movzbl (%eax),%ebx
801049d0:	38 d9                	cmp    %bl,%cl
801049d2:	74 ec                	je     801049c0 <memcmp+0x20>
      return *s1 - *s2;
801049d4:	0f b6 c1             	movzbl %cl,%eax
801049d7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801049d9:	5b                   	pop    %ebx
801049da:	5e                   	pop    %esi
801049db:	5d                   	pop    %ebp
801049dc:	c3                   	ret    
801049dd:	8d 76 00             	lea    0x0(%esi),%esi
801049e0:	5b                   	pop    %ebx
  return 0;
801049e1:	31 c0                	xor    %eax,%eax
}
801049e3:	5e                   	pop    %esi
801049e4:	5d                   	pop    %ebp
801049e5:	c3                   	ret    
801049e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049ed:	8d 76 00             	lea    0x0(%esi),%esi

801049f0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
801049f3:	57                   	push   %edi
801049f4:	8b 55 08             	mov    0x8(%ebp),%edx
801049f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801049fa:	56                   	push   %esi
801049fb:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801049fe:	39 d6                	cmp    %edx,%esi
80104a00:	73 26                	jae    80104a28 <memmove+0x38>
80104a02:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104a05:	39 fa                	cmp    %edi,%edx
80104a07:	73 1f                	jae    80104a28 <memmove+0x38>
80104a09:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104a0c:	85 c9                	test   %ecx,%ecx
80104a0e:	74 0c                	je     80104a1c <memmove+0x2c>
      *--d = *--s;
80104a10:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104a14:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104a17:	83 e8 01             	sub    $0x1,%eax
80104a1a:	73 f4                	jae    80104a10 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104a1c:	5e                   	pop    %esi
80104a1d:	89 d0                	mov    %edx,%eax
80104a1f:	5f                   	pop    %edi
80104a20:	5d                   	pop    %ebp
80104a21:	c3                   	ret    
80104a22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104a28:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104a2b:	89 d7                	mov    %edx,%edi
80104a2d:	85 c9                	test   %ecx,%ecx
80104a2f:	74 eb                	je     80104a1c <memmove+0x2c>
80104a31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104a38:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104a39:	39 c6                	cmp    %eax,%esi
80104a3b:	75 fb                	jne    80104a38 <memmove+0x48>
}
80104a3d:	5e                   	pop    %esi
80104a3e:	89 d0                	mov    %edx,%eax
80104a40:	5f                   	pop    %edi
80104a41:	5d                   	pop    %ebp
80104a42:	c3                   	ret    
80104a43:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a50 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104a50:	eb 9e                	jmp    801049f0 <memmove>
80104a52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104a60 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104a60:	55                   	push   %ebp
80104a61:	89 e5                	mov    %esp,%ebp
80104a63:	56                   	push   %esi
80104a64:	8b 75 10             	mov    0x10(%ebp),%esi
80104a67:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104a6a:	53                   	push   %ebx
80104a6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
80104a6e:	85 f6                	test   %esi,%esi
80104a70:	74 2e                	je     80104aa0 <strncmp+0x40>
80104a72:	01 d6                	add    %edx,%esi
80104a74:	eb 18                	jmp    80104a8e <strncmp+0x2e>
80104a76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a7d:	8d 76 00             	lea    0x0(%esi),%esi
80104a80:	38 d8                	cmp    %bl,%al
80104a82:	75 14                	jne    80104a98 <strncmp+0x38>
    n--, p++, q++;
80104a84:	83 c2 01             	add    $0x1,%edx
80104a87:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104a8a:	39 f2                	cmp    %esi,%edx
80104a8c:	74 12                	je     80104aa0 <strncmp+0x40>
80104a8e:	0f b6 01             	movzbl (%ecx),%eax
80104a91:	0f b6 1a             	movzbl (%edx),%ebx
80104a94:	84 c0                	test   %al,%al
80104a96:	75 e8                	jne    80104a80 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104a98:	29 d8                	sub    %ebx,%eax
}
80104a9a:	5b                   	pop    %ebx
80104a9b:	5e                   	pop    %esi
80104a9c:	5d                   	pop    %ebp
80104a9d:	c3                   	ret    
80104a9e:	66 90                	xchg   %ax,%ax
80104aa0:	5b                   	pop    %ebx
    return 0;
80104aa1:	31 c0                	xor    %eax,%eax
}
80104aa3:	5e                   	pop    %esi
80104aa4:	5d                   	pop    %ebp
80104aa5:	c3                   	ret    
80104aa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aad:	8d 76 00             	lea    0x0(%esi),%esi

80104ab0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104ab0:	55                   	push   %ebp
80104ab1:	89 e5                	mov    %esp,%ebp
80104ab3:	57                   	push   %edi
80104ab4:	56                   	push   %esi
80104ab5:	8b 75 08             	mov    0x8(%ebp),%esi
80104ab8:	53                   	push   %ebx
80104ab9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104abc:	89 f0                	mov    %esi,%eax
80104abe:	eb 15                	jmp    80104ad5 <strncpy+0x25>
80104ac0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104ac4:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104ac7:	83 c0 01             	add    $0x1,%eax
80104aca:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
80104ace:	88 50 ff             	mov    %dl,-0x1(%eax)
80104ad1:	84 d2                	test   %dl,%dl
80104ad3:	74 09                	je     80104ade <strncpy+0x2e>
80104ad5:	89 cb                	mov    %ecx,%ebx
80104ad7:	83 e9 01             	sub    $0x1,%ecx
80104ada:	85 db                	test   %ebx,%ebx
80104adc:	7f e2                	jg     80104ac0 <strncpy+0x10>
    ;
  while(n-- > 0)
80104ade:	89 c2                	mov    %eax,%edx
80104ae0:	85 c9                	test   %ecx,%ecx
80104ae2:	7e 17                	jle    80104afb <strncpy+0x4b>
80104ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104ae8:	83 c2 01             	add    $0x1,%edx
80104aeb:	89 c1                	mov    %eax,%ecx
80104aed:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80104af1:	29 d1                	sub    %edx,%ecx
80104af3:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104af7:	85 c9                	test   %ecx,%ecx
80104af9:	7f ed                	jg     80104ae8 <strncpy+0x38>
  return os;
}
80104afb:	5b                   	pop    %ebx
80104afc:	89 f0                	mov    %esi,%eax
80104afe:	5e                   	pop    %esi
80104aff:	5f                   	pop    %edi
80104b00:	5d                   	pop    %ebp
80104b01:	c3                   	ret    
80104b02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104b10 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	56                   	push   %esi
80104b14:	8b 55 10             	mov    0x10(%ebp),%edx
80104b17:	8b 75 08             	mov    0x8(%ebp),%esi
80104b1a:	53                   	push   %ebx
80104b1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104b1e:	85 d2                	test   %edx,%edx
80104b20:	7e 25                	jle    80104b47 <safestrcpy+0x37>
80104b22:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104b26:	89 f2                	mov    %esi,%edx
80104b28:	eb 16                	jmp    80104b40 <safestrcpy+0x30>
80104b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104b30:	0f b6 08             	movzbl (%eax),%ecx
80104b33:	83 c0 01             	add    $0x1,%eax
80104b36:	83 c2 01             	add    $0x1,%edx
80104b39:	88 4a ff             	mov    %cl,-0x1(%edx)
80104b3c:	84 c9                	test   %cl,%cl
80104b3e:	74 04                	je     80104b44 <safestrcpy+0x34>
80104b40:	39 d8                	cmp    %ebx,%eax
80104b42:	75 ec                	jne    80104b30 <safestrcpy+0x20>
    ;
  *s = 0;
80104b44:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104b47:	89 f0                	mov    %esi,%eax
80104b49:	5b                   	pop    %ebx
80104b4a:	5e                   	pop    %esi
80104b4b:	5d                   	pop    %ebp
80104b4c:	c3                   	ret    
80104b4d:	8d 76 00             	lea    0x0(%esi),%esi

80104b50 <strlen>:

int
strlen(const char *s)
{
80104b50:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104b51:	31 c0                	xor    %eax,%eax
{
80104b53:	89 e5                	mov    %esp,%ebp
80104b55:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104b58:	80 3a 00             	cmpb   $0x0,(%edx)
80104b5b:	74 0c                	je     80104b69 <strlen+0x19>
80104b5d:	8d 76 00             	lea    0x0(%esi),%esi
80104b60:	83 c0 01             	add    $0x1,%eax
80104b63:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104b67:	75 f7                	jne    80104b60 <strlen+0x10>
    ;
  return n;
}
80104b69:	5d                   	pop    %ebp
80104b6a:	c3                   	ret    

80104b6b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104b6b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104b6f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104b73:	55                   	push   %ebp
  pushl %ebx
80104b74:	53                   	push   %ebx
  pushl %esi
80104b75:	56                   	push   %esi
  pushl %edi
80104b76:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104b77:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104b79:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104b7b:	5f                   	pop    %edi
  popl %esi
80104b7c:	5e                   	pop    %esi
  popl %ebx
80104b7d:	5b                   	pop    %ebx
  popl %ebp
80104b7e:	5d                   	pop    %ebp
  ret
80104b7f:	c3                   	ret    

80104b80 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104b80:	55                   	push   %ebp
80104b81:	89 e5                	mov    %esp,%ebp
80104b83:	53                   	push   %ebx
80104b84:	83 ec 04             	sub    $0x4,%esp
80104b87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104b8a:	e8 d1 f0 ff ff       	call   80103c60 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b8f:	8b 00                	mov    (%eax),%eax
80104b91:	39 d8                	cmp    %ebx,%eax
80104b93:	76 1b                	jbe    80104bb0 <fetchint+0x30>
80104b95:	8d 53 04             	lea    0x4(%ebx),%edx
80104b98:	39 d0                	cmp    %edx,%eax
80104b9a:	72 14                	jb     80104bb0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104b9c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b9f:	8b 13                	mov    (%ebx),%edx
80104ba1:	89 10                	mov    %edx,(%eax)
  return 0;
80104ba3:	31 c0                	xor    %eax,%eax
}
80104ba5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ba8:	c9                   	leave  
80104ba9:	c3                   	ret    
80104baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104bb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bb5:	eb ee                	jmp    80104ba5 <fetchint+0x25>
80104bb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bbe:	66 90                	xchg   %ax,%ax

80104bc0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	53                   	push   %ebx
80104bc4:	83 ec 04             	sub    $0x4,%esp
80104bc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104bca:	e8 91 f0 ff ff       	call   80103c60 <myproc>

  if(addr >= curproc->sz)
80104bcf:	39 18                	cmp    %ebx,(%eax)
80104bd1:	76 2d                	jbe    80104c00 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104bd3:	8b 55 0c             	mov    0xc(%ebp),%edx
80104bd6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104bd8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104bda:	39 d3                	cmp    %edx,%ebx
80104bdc:	73 22                	jae    80104c00 <fetchstr+0x40>
80104bde:	89 d8                	mov    %ebx,%eax
80104be0:	eb 0d                	jmp    80104bef <fetchstr+0x2f>
80104be2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104be8:	83 c0 01             	add    $0x1,%eax
80104beb:	39 c2                	cmp    %eax,%edx
80104bed:	76 11                	jbe    80104c00 <fetchstr+0x40>
    if(*s == 0)
80104bef:	80 38 00             	cmpb   $0x0,(%eax)
80104bf2:	75 f4                	jne    80104be8 <fetchstr+0x28>
      return s - *pp;
80104bf4:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104bf6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bf9:	c9                   	leave  
80104bfa:	c3                   	ret    
80104bfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bff:	90                   	nop
80104c00:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104c03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c08:	c9                   	leave  
80104c09:	c3                   	ret    
80104c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c10 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104c10:	55                   	push   %ebp
80104c11:	89 e5                	mov    %esp,%ebp
80104c13:	56                   	push   %esi
80104c14:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c15:	e8 46 f0 ff ff       	call   80103c60 <myproc>
80104c1a:	8b 55 08             	mov    0x8(%ebp),%edx
80104c1d:	8b 40 18             	mov    0x18(%eax),%eax
80104c20:	8b 40 44             	mov    0x44(%eax),%eax
80104c23:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c26:	e8 35 f0 ff ff       	call   80103c60 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c2b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c2e:	8b 00                	mov    (%eax),%eax
80104c30:	39 c6                	cmp    %eax,%esi
80104c32:	73 1c                	jae    80104c50 <argint+0x40>
80104c34:	8d 53 08             	lea    0x8(%ebx),%edx
80104c37:	39 d0                	cmp    %edx,%eax
80104c39:	72 15                	jb     80104c50 <argint+0x40>
  *ip = *(int*)(addr);
80104c3b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c3e:	8b 53 04             	mov    0x4(%ebx),%edx
80104c41:	89 10                	mov    %edx,(%eax)
  return 0;
80104c43:	31 c0                	xor    %eax,%eax
}
80104c45:	5b                   	pop    %ebx
80104c46:	5e                   	pop    %esi
80104c47:	5d                   	pop    %ebp
80104c48:	c3                   	ret    
80104c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104c50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c55:	eb ee                	jmp    80104c45 <argint+0x35>
80104c57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c5e:	66 90                	xchg   %ax,%ax

80104c60 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104c60:	55                   	push   %ebp
80104c61:	89 e5                	mov    %esp,%ebp
80104c63:	57                   	push   %edi
80104c64:	56                   	push   %esi
80104c65:	53                   	push   %ebx
80104c66:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104c69:	e8 f2 ef ff ff       	call   80103c60 <myproc>
80104c6e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c70:	e8 eb ef ff ff       	call   80103c60 <myproc>
80104c75:	8b 55 08             	mov    0x8(%ebp),%edx
80104c78:	8b 40 18             	mov    0x18(%eax),%eax
80104c7b:	8b 40 44             	mov    0x44(%eax),%eax
80104c7e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c81:	e8 da ef ff ff       	call   80103c60 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c86:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c89:	8b 00                	mov    (%eax),%eax
80104c8b:	39 c7                	cmp    %eax,%edi
80104c8d:	73 31                	jae    80104cc0 <argptr+0x60>
80104c8f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104c92:	39 c8                	cmp    %ecx,%eax
80104c94:	72 2a                	jb     80104cc0 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104c96:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104c99:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104c9c:	85 d2                	test   %edx,%edx
80104c9e:	78 20                	js     80104cc0 <argptr+0x60>
80104ca0:	8b 16                	mov    (%esi),%edx
80104ca2:	39 c2                	cmp    %eax,%edx
80104ca4:	76 1a                	jbe    80104cc0 <argptr+0x60>
80104ca6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104ca9:	01 c3                	add    %eax,%ebx
80104cab:	39 da                	cmp    %ebx,%edx
80104cad:	72 11                	jb     80104cc0 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104caf:	8b 55 0c             	mov    0xc(%ebp),%edx
80104cb2:	89 02                	mov    %eax,(%edx)
  return 0;
80104cb4:	31 c0                	xor    %eax,%eax
}
80104cb6:	83 c4 0c             	add    $0xc,%esp
80104cb9:	5b                   	pop    %ebx
80104cba:	5e                   	pop    %esi
80104cbb:	5f                   	pop    %edi
80104cbc:	5d                   	pop    %ebp
80104cbd:	c3                   	ret    
80104cbe:	66 90                	xchg   %ax,%ax
    return -1;
80104cc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cc5:	eb ef                	jmp    80104cb6 <argptr+0x56>
80104cc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cce:	66 90                	xchg   %ax,%ax

80104cd0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104cd0:	55                   	push   %ebp
80104cd1:	89 e5                	mov    %esp,%ebp
80104cd3:	56                   	push   %esi
80104cd4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104cd5:	e8 86 ef ff ff       	call   80103c60 <myproc>
80104cda:	8b 55 08             	mov    0x8(%ebp),%edx
80104cdd:	8b 40 18             	mov    0x18(%eax),%eax
80104ce0:	8b 40 44             	mov    0x44(%eax),%eax
80104ce3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104ce6:	e8 75 ef ff ff       	call   80103c60 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ceb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104cee:	8b 00                	mov    (%eax),%eax
80104cf0:	39 c6                	cmp    %eax,%esi
80104cf2:	73 44                	jae    80104d38 <argstr+0x68>
80104cf4:	8d 53 08             	lea    0x8(%ebx),%edx
80104cf7:	39 d0                	cmp    %edx,%eax
80104cf9:	72 3d                	jb     80104d38 <argstr+0x68>
  *ip = *(int*)(addr);
80104cfb:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104cfe:	e8 5d ef ff ff       	call   80103c60 <myproc>
  if(addr >= curproc->sz)
80104d03:	3b 18                	cmp    (%eax),%ebx
80104d05:	73 31                	jae    80104d38 <argstr+0x68>
  *pp = (char*)addr;
80104d07:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d0a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104d0c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104d0e:	39 d3                	cmp    %edx,%ebx
80104d10:	73 26                	jae    80104d38 <argstr+0x68>
80104d12:	89 d8                	mov    %ebx,%eax
80104d14:	eb 11                	jmp    80104d27 <argstr+0x57>
80104d16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d1d:	8d 76 00             	lea    0x0(%esi),%esi
80104d20:	83 c0 01             	add    $0x1,%eax
80104d23:	39 c2                	cmp    %eax,%edx
80104d25:	76 11                	jbe    80104d38 <argstr+0x68>
    if(*s == 0)
80104d27:	80 38 00             	cmpb   $0x0,(%eax)
80104d2a:	75 f4                	jne    80104d20 <argstr+0x50>
      return s - *pp;
80104d2c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104d2e:	5b                   	pop    %ebx
80104d2f:	5e                   	pop    %esi
80104d30:	5d                   	pop    %ebp
80104d31:	c3                   	ret    
80104d32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d38:	5b                   	pop    %ebx
    return -1;
80104d39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d3e:	5e                   	pop    %esi
80104d3f:	5d                   	pop    %ebp
80104d40:	c3                   	ret    
80104d41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d4f:	90                   	nop

80104d50 <syscall>:
[SYS_countptp] sys_countptp,
};

void
syscall(void)
{
80104d50:	55                   	push   %ebp
80104d51:	89 e5                	mov    %esp,%ebp
80104d53:	53                   	push   %ebx
80104d54:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104d57:	e8 04 ef ff ff       	call   80103c60 <myproc>
80104d5c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104d5e:	8b 40 18             	mov    0x18(%eax),%eax
80104d61:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104d64:	8d 50 ff             	lea    -0x1(%eax),%edx
80104d67:	83 fa 18             	cmp    $0x18,%edx
80104d6a:	77 24                	ja     80104d90 <syscall+0x40>
80104d6c:	8b 14 85 a0 7d 10 80 	mov    -0x7fef8260(,%eax,4),%edx
80104d73:	85 d2                	test   %edx,%edx
80104d75:	74 19                	je     80104d90 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104d77:	ff d2                	call   *%edx
80104d79:	89 c2                	mov    %eax,%edx
80104d7b:	8b 43 18             	mov    0x18(%ebx),%eax
80104d7e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104d81:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d84:	c9                   	leave  
80104d85:	c3                   	ret    
80104d86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d8d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104d90:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104d91:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104d94:	50                   	push   %eax
80104d95:	ff 73 10             	push   0x10(%ebx)
80104d98:	68 7d 7d 10 80       	push   $0x80107d7d
80104d9d:	e8 fe b8 ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80104da2:	8b 43 18             	mov    0x18(%ebx),%eax
80104da5:	83 c4 10             	add    $0x10,%esp
80104da8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104daf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104db2:	c9                   	leave  
80104db3:	c3                   	ret    
80104db4:	66 90                	xchg   %ax,%ax
80104db6:	66 90                	xchg   %ax,%ax
80104db8:	66 90                	xchg   %ax,%ax
80104dba:	66 90                	xchg   %ax,%ax
80104dbc:	66 90                	xchg   %ax,%ax
80104dbe:	66 90                	xchg   %ax,%ax

80104dc0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104dc0:	55                   	push   %ebp
80104dc1:	89 e5                	mov    %esp,%ebp
80104dc3:	57                   	push   %edi
80104dc4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104dc5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104dc8:	53                   	push   %ebx
80104dc9:	83 ec 34             	sub    $0x34,%esp
80104dcc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104dcf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104dd2:	57                   	push   %edi
80104dd3:	50                   	push   %eax
{
80104dd4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104dd7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104dda:	e8 e1 d2 ff ff       	call   801020c0 <nameiparent>
80104ddf:	83 c4 10             	add    $0x10,%esp
80104de2:	85 c0                	test   %eax,%eax
80104de4:	0f 84 46 01 00 00    	je     80104f30 <create+0x170>
    return 0;
  ilock(dp);
80104dea:	83 ec 0c             	sub    $0xc,%esp
80104ded:	89 c3                	mov    %eax,%ebx
80104def:	50                   	push   %eax
80104df0:	e8 8b c9 ff ff       	call   80101780 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104df5:	83 c4 0c             	add    $0xc,%esp
80104df8:	6a 00                	push   $0x0
80104dfa:	57                   	push   %edi
80104dfb:	53                   	push   %ebx
80104dfc:	e8 df ce ff ff       	call   80101ce0 <dirlookup>
80104e01:	83 c4 10             	add    $0x10,%esp
80104e04:	89 c6                	mov    %eax,%esi
80104e06:	85 c0                	test   %eax,%eax
80104e08:	74 56                	je     80104e60 <create+0xa0>
    iunlockput(dp);
80104e0a:	83 ec 0c             	sub    $0xc,%esp
80104e0d:	53                   	push   %ebx
80104e0e:	e8 fd cb ff ff       	call   80101a10 <iunlockput>
    ilock(ip);
80104e13:	89 34 24             	mov    %esi,(%esp)
80104e16:	e8 65 c9 ff ff       	call   80101780 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104e1b:	83 c4 10             	add    $0x10,%esp
80104e1e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104e23:	75 1b                	jne    80104e40 <create+0x80>
80104e25:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104e2a:	75 14                	jne    80104e40 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104e2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e2f:	89 f0                	mov    %esi,%eax
80104e31:	5b                   	pop    %ebx
80104e32:	5e                   	pop    %esi
80104e33:	5f                   	pop    %edi
80104e34:	5d                   	pop    %ebp
80104e35:	c3                   	ret    
80104e36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e3d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104e40:	83 ec 0c             	sub    $0xc,%esp
80104e43:	56                   	push   %esi
    return 0;
80104e44:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104e46:	e8 c5 cb ff ff       	call   80101a10 <iunlockput>
    return 0;
80104e4b:	83 c4 10             	add    $0x10,%esp
}
80104e4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e51:	89 f0                	mov    %esi,%eax
80104e53:	5b                   	pop    %ebx
80104e54:	5e                   	pop    %esi
80104e55:	5f                   	pop    %edi
80104e56:	5d                   	pop    %ebp
80104e57:	c3                   	ret    
80104e58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e5f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104e60:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104e64:	83 ec 08             	sub    $0x8,%esp
80104e67:	50                   	push   %eax
80104e68:	ff 33                	push   (%ebx)
80104e6a:	e8 a1 c7 ff ff       	call   80101610 <ialloc>
80104e6f:	83 c4 10             	add    $0x10,%esp
80104e72:	89 c6                	mov    %eax,%esi
80104e74:	85 c0                	test   %eax,%eax
80104e76:	0f 84 cd 00 00 00    	je     80104f49 <create+0x189>
  ilock(ip);
80104e7c:	83 ec 0c             	sub    $0xc,%esp
80104e7f:	50                   	push   %eax
80104e80:	e8 fb c8 ff ff       	call   80101780 <ilock>
  ip->major = major;
80104e85:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104e89:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104e8d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104e91:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104e95:	b8 01 00 00 00       	mov    $0x1,%eax
80104e9a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104e9e:	89 34 24             	mov    %esi,(%esp)
80104ea1:	e8 2a c8 ff ff       	call   801016d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104ea6:	83 c4 10             	add    $0x10,%esp
80104ea9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104eae:	74 30                	je     80104ee0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104eb0:	83 ec 04             	sub    $0x4,%esp
80104eb3:	ff 76 04             	push   0x4(%esi)
80104eb6:	57                   	push   %edi
80104eb7:	53                   	push   %ebx
80104eb8:	e8 23 d1 ff ff       	call   80101fe0 <dirlink>
80104ebd:	83 c4 10             	add    $0x10,%esp
80104ec0:	85 c0                	test   %eax,%eax
80104ec2:	78 78                	js     80104f3c <create+0x17c>
  iunlockput(dp);
80104ec4:	83 ec 0c             	sub    $0xc,%esp
80104ec7:	53                   	push   %ebx
80104ec8:	e8 43 cb ff ff       	call   80101a10 <iunlockput>
  return ip;
80104ecd:	83 c4 10             	add    $0x10,%esp
}
80104ed0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ed3:	89 f0                	mov    %esi,%eax
80104ed5:	5b                   	pop    %ebx
80104ed6:	5e                   	pop    %esi
80104ed7:	5f                   	pop    %edi
80104ed8:	5d                   	pop    %ebp
80104ed9:	c3                   	ret    
80104eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104ee0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104ee3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104ee8:	53                   	push   %ebx
80104ee9:	e8 e2 c7 ff ff       	call   801016d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104eee:	83 c4 0c             	add    $0xc,%esp
80104ef1:	ff 76 04             	push   0x4(%esi)
80104ef4:	68 24 7e 10 80       	push   $0x80107e24
80104ef9:	56                   	push   %esi
80104efa:	e8 e1 d0 ff ff       	call   80101fe0 <dirlink>
80104eff:	83 c4 10             	add    $0x10,%esp
80104f02:	85 c0                	test   %eax,%eax
80104f04:	78 18                	js     80104f1e <create+0x15e>
80104f06:	83 ec 04             	sub    $0x4,%esp
80104f09:	ff 73 04             	push   0x4(%ebx)
80104f0c:	68 23 7e 10 80       	push   $0x80107e23
80104f11:	56                   	push   %esi
80104f12:	e8 c9 d0 ff ff       	call   80101fe0 <dirlink>
80104f17:	83 c4 10             	add    $0x10,%esp
80104f1a:	85 c0                	test   %eax,%eax
80104f1c:	79 92                	jns    80104eb0 <create+0xf0>
      panic("create dots");
80104f1e:	83 ec 0c             	sub    $0xc,%esp
80104f21:	68 17 7e 10 80       	push   $0x80107e17
80104f26:	e8 55 b4 ff ff       	call   80100380 <panic>
80104f2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f2f:	90                   	nop
}
80104f30:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104f33:	31 f6                	xor    %esi,%esi
}
80104f35:	5b                   	pop    %ebx
80104f36:	89 f0                	mov    %esi,%eax
80104f38:	5e                   	pop    %esi
80104f39:	5f                   	pop    %edi
80104f3a:	5d                   	pop    %ebp
80104f3b:	c3                   	ret    
    panic("create: dirlink");
80104f3c:	83 ec 0c             	sub    $0xc,%esp
80104f3f:	68 26 7e 10 80       	push   $0x80107e26
80104f44:	e8 37 b4 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104f49:	83 ec 0c             	sub    $0xc,%esp
80104f4c:	68 08 7e 10 80       	push   $0x80107e08
80104f51:	e8 2a b4 ff ff       	call   80100380 <panic>
80104f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f5d:	8d 76 00             	lea    0x0(%esi),%esi

80104f60 <sys_dup>:
{
80104f60:	55                   	push   %ebp
80104f61:	89 e5                	mov    %esp,%ebp
80104f63:	56                   	push   %esi
80104f64:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f65:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104f68:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f6b:	50                   	push   %eax
80104f6c:	6a 00                	push   $0x0
80104f6e:	e8 9d fc ff ff       	call   80104c10 <argint>
80104f73:	83 c4 10             	add    $0x10,%esp
80104f76:	85 c0                	test   %eax,%eax
80104f78:	78 36                	js     80104fb0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f7a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f7e:	77 30                	ja     80104fb0 <sys_dup+0x50>
80104f80:	e8 db ec ff ff       	call   80103c60 <myproc>
80104f85:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f88:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104f8c:	85 f6                	test   %esi,%esi
80104f8e:	74 20                	je     80104fb0 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104f90:	e8 cb ec ff ff       	call   80103c60 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104f95:	31 db                	xor    %ebx,%ebx
80104f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f9e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80104fa0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104fa4:	85 d2                	test   %edx,%edx
80104fa6:	74 18                	je     80104fc0 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104fa8:	83 c3 01             	add    $0x1,%ebx
80104fab:	83 fb 10             	cmp    $0x10,%ebx
80104fae:	75 f0                	jne    80104fa0 <sys_dup+0x40>
}
80104fb0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104fb3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104fb8:	89 d8                	mov    %ebx,%eax
80104fba:	5b                   	pop    %ebx
80104fbb:	5e                   	pop    %esi
80104fbc:	5d                   	pop    %ebp
80104fbd:	c3                   	ret    
80104fbe:	66 90                	xchg   %ax,%ax
  filedup(f);
80104fc0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104fc3:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104fc7:	56                   	push   %esi
80104fc8:	e8 d3 be ff ff       	call   80100ea0 <filedup>
  return fd;
80104fcd:	83 c4 10             	add    $0x10,%esp
}
80104fd0:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fd3:	89 d8                	mov    %ebx,%eax
80104fd5:	5b                   	pop    %ebx
80104fd6:	5e                   	pop    %esi
80104fd7:	5d                   	pop    %ebp
80104fd8:	c3                   	ret    
80104fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104fe0 <sys_read>:
{
80104fe0:	55                   	push   %ebp
80104fe1:	89 e5                	mov    %esp,%ebp
80104fe3:	56                   	push   %esi
80104fe4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104fe5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104fe8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104feb:	53                   	push   %ebx
80104fec:	6a 00                	push   $0x0
80104fee:	e8 1d fc ff ff       	call   80104c10 <argint>
80104ff3:	83 c4 10             	add    $0x10,%esp
80104ff6:	85 c0                	test   %eax,%eax
80104ff8:	78 5e                	js     80105058 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104ffa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104ffe:	77 58                	ja     80105058 <sys_read+0x78>
80105000:	e8 5b ec ff ff       	call   80103c60 <myproc>
80105005:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105008:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010500c:	85 f6                	test   %esi,%esi
8010500e:	74 48                	je     80105058 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105010:	83 ec 08             	sub    $0x8,%esp
80105013:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105016:	50                   	push   %eax
80105017:	6a 02                	push   $0x2
80105019:	e8 f2 fb ff ff       	call   80104c10 <argint>
8010501e:	83 c4 10             	add    $0x10,%esp
80105021:	85 c0                	test   %eax,%eax
80105023:	78 33                	js     80105058 <sys_read+0x78>
80105025:	83 ec 04             	sub    $0x4,%esp
80105028:	ff 75 f0             	push   -0x10(%ebp)
8010502b:	53                   	push   %ebx
8010502c:	6a 01                	push   $0x1
8010502e:	e8 2d fc ff ff       	call   80104c60 <argptr>
80105033:	83 c4 10             	add    $0x10,%esp
80105036:	85 c0                	test   %eax,%eax
80105038:	78 1e                	js     80105058 <sys_read+0x78>
  return fileread(f, p, n);
8010503a:	83 ec 04             	sub    $0x4,%esp
8010503d:	ff 75 f0             	push   -0x10(%ebp)
80105040:	ff 75 f4             	push   -0xc(%ebp)
80105043:	56                   	push   %esi
80105044:	e8 d7 bf ff ff       	call   80101020 <fileread>
80105049:	83 c4 10             	add    $0x10,%esp
}
8010504c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010504f:	5b                   	pop    %ebx
80105050:	5e                   	pop    %esi
80105051:	5d                   	pop    %ebp
80105052:	c3                   	ret    
80105053:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105057:	90                   	nop
    return -1;
80105058:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010505d:	eb ed                	jmp    8010504c <sys_read+0x6c>
8010505f:	90                   	nop

80105060 <sys_write>:
{
80105060:	55                   	push   %ebp
80105061:	89 e5                	mov    %esp,%ebp
80105063:	56                   	push   %esi
80105064:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105065:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105068:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010506b:	53                   	push   %ebx
8010506c:	6a 00                	push   $0x0
8010506e:	e8 9d fb ff ff       	call   80104c10 <argint>
80105073:	83 c4 10             	add    $0x10,%esp
80105076:	85 c0                	test   %eax,%eax
80105078:	78 5e                	js     801050d8 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010507a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010507e:	77 58                	ja     801050d8 <sys_write+0x78>
80105080:	e8 db eb ff ff       	call   80103c60 <myproc>
80105085:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105088:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010508c:	85 f6                	test   %esi,%esi
8010508e:	74 48                	je     801050d8 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105090:	83 ec 08             	sub    $0x8,%esp
80105093:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105096:	50                   	push   %eax
80105097:	6a 02                	push   $0x2
80105099:	e8 72 fb ff ff       	call   80104c10 <argint>
8010509e:	83 c4 10             	add    $0x10,%esp
801050a1:	85 c0                	test   %eax,%eax
801050a3:	78 33                	js     801050d8 <sys_write+0x78>
801050a5:	83 ec 04             	sub    $0x4,%esp
801050a8:	ff 75 f0             	push   -0x10(%ebp)
801050ab:	53                   	push   %ebx
801050ac:	6a 01                	push   $0x1
801050ae:	e8 ad fb ff ff       	call   80104c60 <argptr>
801050b3:	83 c4 10             	add    $0x10,%esp
801050b6:	85 c0                	test   %eax,%eax
801050b8:	78 1e                	js     801050d8 <sys_write+0x78>
  return filewrite(f, p, n);
801050ba:	83 ec 04             	sub    $0x4,%esp
801050bd:	ff 75 f0             	push   -0x10(%ebp)
801050c0:	ff 75 f4             	push   -0xc(%ebp)
801050c3:	56                   	push   %esi
801050c4:	e8 e7 bf ff ff       	call   801010b0 <filewrite>
801050c9:	83 c4 10             	add    $0x10,%esp
}
801050cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050cf:	5b                   	pop    %ebx
801050d0:	5e                   	pop    %esi
801050d1:	5d                   	pop    %ebp
801050d2:	c3                   	ret    
801050d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050d7:	90                   	nop
    return -1;
801050d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050dd:	eb ed                	jmp    801050cc <sys_write+0x6c>
801050df:	90                   	nop

801050e0 <sys_close>:
{
801050e0:	55                   	push   %ebp
801050e1:	89 e5                	mov    %esp,%ebp
801050e3:	56                   	push   %esi
801050e4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801050e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801050e8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801050eb:	50                   	push   %eax
801050ec:	6a 00                	push   $0x0
801050ee:	e8 1d fb ff ff       	call   80104c10 <argint>
801050f3:	83 c4 10             	add    $0x10,%esp
801050f6:	85 c0                	test   %eax,%eax
801050f8:	78 3e                	js     80105138 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801050fa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801050fe:	77 38                	ja     80105138 <sys_close+0x58>
80105100:	e8 5b eb ff ff       	call   80103c60 <myproc>
80105105:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105108:	8d 5a 08             	lea    0x8(%edx),%ebx
8010510b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010510f:	85 f6                	test   %esi,%esi
80105111:	74 25                	je     80105138 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105113:	e8 48 eb ff ff       	call   80103c60 <myproc>
  fileclose(f);
80105118:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010511b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105122:	00 
  fileclose(f);
80105123:	56                   	push   %esi
80105124:	e8 c7 bd ff ff       	call   80100ef0 <fileclose>
  return 0;
80105129:	83 c4 10             	add    $0x10,%esp
8010512c:	31 c0                	xor    %eax,%eax
}
8010512e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105131:	5b                   	pop    %ebx
80105132:	5e                   	pop    %esi
80105133:	5d                   	pop    %ebp
80105134:	c3                   	ret    
80105135:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105138:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010513d:	eb ef                	jmp    8010512e <sys_close+0x4e>
8010513f:	90                   	nop

80105140 <sys_fstat>:
{
80105140:	55                   	push   %ebp
80105141:	89 e5                	mov    %esp,%ebp
80105143:	56                   	push   %esi
80105144:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105145:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105148:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010514b:	53                   	push   %ebx
8010514c:	6a 00                	push   $0x0
8010514e:	e8 bd fa ff ff       	call   80104c10 <argint>
80105153:	83 c4 10             	add    $0x10,%esp
80105156:	85 c0                	test   %eax,%eax
80105158:	78 46                	js     801051a0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010515a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010515e:	77 40                	ja     801051a0 <sys_fstat+0x60>
80105160:	e8 fb ea ff ff       	call   80103c60 <myproc>
80105165:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105168:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010516c:	85 f6                	test   %esi,%esi
8010516e:	74 30                	je     801051a0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105170:	83 ec 04             	sub    $0x4,%esp
80105173:	6a 14                	push   $0x14
80105175:	53                   	push   %ebx
80105176:	6a 01                	push   $0x1
80105178:	e8 e3 fa ff ff       	call   80104c60 <argptr>
8010517d:	83 c4 10             	add    $0x10,%esp
80105180:	85 c0                	test   %eax,%eax
80105182:	78 1c                	js     801051a0 <sys_fstat+0x60>
  return filestat(f, st);
80105184:	83 ec 08             	sub    $0x8,%esp
80105187:	ff 75 f4             	push   -0xc(%ebp)
8010518a:	56                   	push   %esi
8010518b:	e8 40 be ff ff       	call   80100fd0 <filestat>
80105190:	83 c4 10             	add    $0x10,%esp
}
80105193:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105196:	5b                   	pop    %ebx
80105197:	5e                   	pop    %esi
80105198:	5d                   	pop    %ebp
80105199:	c3                   	ret    
8010519a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801051a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051a5:	eb ec                	jmp    80105193 <sys_fstat+0x53>
801051a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051ae:	66 90                	xchg   %ax,%ax

801051b0 <sys_link>:
{
801051b0:	55                   	push   %ebp
801051b1:	89 e5                	mov    %esp,%ebp
801051b3:	57                   	push   %edi
801051b4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801051b5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801051b8:	53                   	push   %ebx
801051b9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801051bc:	50                   	push   %eax
801051bd:	6a 00                	push   $0x0
801051bf:	e8 0c fb ff ff       	call   80104cd0 <argstr>
801051c4:	83 c4 10             	add    $0x10,%esp
801051c7:	85 c0                	test   %eax,%eax
801051c9:	0f 88 fb 00 00 00    	js     801052ca <sys_link+0x11a>
801051cf:	83 ec 08             	sub    $0x8,%esp
801051d2:	8d 45 d0             	lea    -0x30(%ebp),%eax
801051d5:	50                   	push   %eax
801051d6:	6a 01                	push   $0x1
801051d8:	e8 f3 fa ff ff       	call   80104cd0 <argstr>
801051dd:	83 c4 10             	add    $0x10,%esp
801051e0:	85 c0                	test   %eax,%eax
801051e2:	0f 88 e2 00 00 00    	js     801052ca <sys_link+0x11a>
  begin_op();
801051e8:	e8 63 de ff ff       	call   80103050 <begin_op>
  if((ip = namei(old)) == 0){
801051ed:	83 ec 0c             	sub    $0xc,%esp
801051f0:	ff 75 d4             	push   -0x2c(%ebp)
801051f3:	e8 a8 ce ff ff       	call   801020a0 <namei>
801051f8:	83 c4 10             	add    $0x10,%esp
801051fb:	89 c3                	mov    %eax,%ebx
801051fd:	85 c0                	test   %eax,%eax
801051ff:	0f 84 e4 00 00 00    	je     801052e9 <sys_link+0x139>
  ilock(ip);
80105205:	83 ec 0c             	sub    $0xc,%esp
80105208:	50                   	push   %eax
80105209:	e8 72 c5 ff ff       	call   80101780 <ilock>
  if(ip->type == T_DIR){
8010520e:	83 c4 10             	add    $0x10,%esp
80105211:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105216:	0f 84 b5 00 00 00    	je     801052d1 <sys_link+0x121>
  iupdate(ip);
8010521c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010521f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105224:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105227:	53                   	push   %ebx
80105228:	e8 a3 c4 ff ff       	call   801016d0 <iupdate>
  iunlock(ip);
8010522d:	89 1c 24             	mov    %ebx,(%esp)
80105230:	e8 2b c6 ff ff       	call   80101860 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105235:	58                   	pop    %eax
80105236:	5a                   	pop    %edx
80105237:	57                   	push   %edi
80105238:	ff 75 d0             	push   -0x30(%ebp)
8010523b:	e8 80 ce ff ff       	call   801020c0 <nameiparent>
80105240:	83 c4 10             	add    $0x10,%esp
80105243:	89 c6                	mov    %eax,%esi
80105245:	85 c0                	test   %eax,%eax
80105247:	74 5b                	je     801052a4 <sys_link+0xf4>
  ilock(dp);
80105249:	83 ec 0c             	sub    $0xc,%esp
8010524c:	50                   	push   %eax
8010524d:	e8 2e c5 ff ff       	call   80101780 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105252:	8b 03                	mov    (%ebx),%eax
80105254:	83 c4 10             	add    $0x10,%esp
80105257:	39 06                	cmp    %eax,(%esi)
80105259:	75 3d                	jne    80105298 <sys_link+0xe8>
8010525b:	83 ec 04             	sub    $0x4,%esp
8010525e:	ff 73 04             	push   0x4(%ebx)
80105261:	57                   	push   %edi
80105262:	56                   	push   %esi
80105263:	e8 78 cd ff ff       	call   80101fe0 <dirlink>
80105268:	83 c4 10             	add    $0x10,%esp
8010526b:	85 c0                	test   %eax,%eax
8010526d:	78 29                	js     80105298 <sys_link+0xe8>
  iunlockput(dp);
8010526f:	83 ec 0c             	sub    $0xc,%esp
80105272:	56                   	push   %esi
80105273:	e8 98 c7 ff ff       	call   80101a10 <iunlockput>
  iput(ip);
80105278:	89 1c 24             	mov    %ebx,(%esp)
8010527b:	e8 30 c6 ff ff       	call   801018b0 <iput>
  end_op();
80105280:	e8 3b de ff ff       	call   801030c0 <end_op>
  return 0;
80105285:	83 c4 10             	add    $0x10,%esp
80105288:	31 c0                	xor    %eax,%eax
}
8010528a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010528d:	5b                   	pop    %ebx
8010528e:	5e                   	pop    %esi
8010528f:	5f                   	pop    %edi
80105290:	5d                   	pop    %ebp
80105291:	c3                   	ret    
80105292:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105298:	83 ec 0c             	sub    $0xc,%esp
8010529b:	56                   	push   %esi
8010529c:	e8 6f c7 ff ff       	call   80101a10 <iunlockput>
    goto bad;
801052a1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801052a4:	83 ec 0c             	sub    $0xc,%esp
801052a7:	53                   	push   %ebx
801052a8:	e8 d3 c4 ff ff       	call   80101780 <ilock>
  ip->nlink--;
801052ad:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801052b2:	89 1c 24             	mov    %ebx,(%esp)
801052b5:	e8 16 c4 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
801052ba:	89 1c 24             	mov    %ebx,(%esp)
801052bd:	e8 4e c7 ff ff       	call   80101a10 <iunlockput>
  end_op();
801052c2:	e8 f9 dd ff ff       	call   801030c0 <end_op>
  return -1;
801052c7:	83 c4 10             	add    $0x10,%esp
801052ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052cf:	eb b9                	jmp    8010528a <sys_link+0xda>
    iunlockput(ip);
801052d1:	83 ec 0c             	sub    $0xc,%esp
801052d4:	53                   	push   %ebx
801052d5:	e8 36 c7 ff ff       	call   80101a10 <iunlockput>
    end_op();
801052da:	e8 e1 dd ff ff       	call   801030c0 <end_op>
    return -1;
801052df:	83 c4 10             	add    $0x10,%esp
801052e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052e7:	eb a1                	jmp    8010528a <sys_link+0xda>
    end_op();
801052e9:	e8 d2 dd ff ff       	call   801030c0 <end_op>
    return -1;
801052ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052f3:	eb 95                	jmp    8010528a <sys_link+0xda>
801052f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105300 <sys_unlink>:
{
80105300:	55                   	push   %ebp
80105301:	89 e5                	mov    %esp,%ebp
80105303:	57                   	push   %edi
80105304:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105305:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105308:	53                   	push   %ebx
80105309:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010530c:	50                   	push   %eax
8010530d:	6a 00                	push   $0x0
8010530f:	e8 bc f9 ff ff       	call   80104cd0 <argstr>
80105314:	83 c4 10             	add    $0x10,%esp
80105317:	85 c0                	test   %eax,%eax
80105319:	0f 88 7a 01 00 00    	js     80105499 <sys_unlink+0x199>
  begin_op();
8010531f:	e8 2c dd ff ff       	call   80103050 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105324:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105327:	83 ec 08             	sub    $0x8,%esp
8010532a:	53                   	push   %ebx
8010532b:	ff 75 c0             	push   -0x40(%ebp)
8010532e:	e8 8d cd ff ff       	call   801020c0 <nameiparent>
80105333:	83 c4 10             	add    $0x10,%esp
80105336:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105339:	85 c0                	test   %eax,%eax
8010533b:	0f 84 62 01 00 00    	je     801054a3 <sys_unlink+0x1a3>
  ilock(dp);
80105341:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105344:	83 ec 0c             	sub    $0xc,%esp
80105347:	57                   	push   %edi
80105348:	e8 33 c4 ff ff       	call   80101780 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010534d:	58                   	pop    %eax
8010534e:	5a                   	pop    %edx
8010534f:	68 24 7e 10 80       	push   $0x80107e24
80105354:	53                   	push   %ebx
80105355:	e8 66 c9 ff ff       	call   80101cc0 <namecmp>
8010535a:	83 c4 10             	add    $0x10,%esp
8010535d:	85 c0                	test   %eax,%eax
8010535f:	0f 84 fb 00 00 00    	je     80105460 <sys_unlink+0x160>
80105365:	83 ec 08             	sub    $0x8,%esp
80105368:	68 23 7e 10 80       	push   $0x80107e23
8010536d:	53                   	push   %ebx
8010536e:	e8 4d c9 ff ff       	call   80101cc0 <namecmp>
80105373:	83 c4 10             	add    $0x10,%esp
80105376:	85 c0                	test   %eax,%eax
80105378:	0f 84 e2 00 00 00    	je     80105460 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010537e:	83 ec 04             	sub    $0x4,%esp
80105381:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105384:	50                   	push   %eax
80105385:	53                   	push   %ebx
80105386:	57                   	push   %edi
80105387:	e8 54 c9 ff ff       	call   80101ce0 <dirlookup>
8010538c:	83 c4 10             	add    $0x10,%esp
8010538f:	89 c3                	mov    %eax,%ebx
80105391:	85 c0                	test   %eax,%eax
80105393:	0f 84 c7 00 00 00    	je     80105460 <sys_unlink+0x160>
  ilock(ip);
80105399:	83 ec 0c             	sub    $0xc,%esp
8010539c:	50                   	push   %eax
8010539d:	e8 de c3 ff ff       	call   80101780 <ilock>
  if(ip->nlink < 1)
801053a2:	83 c4 10             	add    $0x10,%esp
801053a5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801053aa:	0f 8e 1c 01 00 00    	jle    801054cc <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
801053b0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053b5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801053b8:	74 66                	je     80105420 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801053ba:	83 ec 04             	sub    $0x4,%esp
801053bd:	6a 10                	push   $0x10
801053bf:	6a 00                	push   $0x0
801053c1:	57                   	push   %edi
801053c2:	e8 89 f5 ff ff       	call   80104950 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801053c7:	6a 10                	push   $0x10
801053c9:	ff 75 c4             	push   -0x3c(%ebp)
801053cc:	57                   	push   %edi
801053cd:	ff 75 b4             	push   -0x4c(%ebp)
801053d0:	e8 bb c7 ff ff       	call   80101b90 <writei>
801053d5:	83 c4 20             	add    $0x20,%esp
801053d8:	83 f8 10             	cmp    $0x10,%eax
801053db:	0f 85 de 00 00 00    	jne    801054bf <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
801053e1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053e6:	0f 84 94 00 00 00    	je     80105480 <sys_unlink+0x180>
  iunlockput(dp);
801053ec:	83 ec 0c             	sub    $0xc,%esp
801053ef:	ff 75 b4             	push   -0x4c(%ebp)
801053f2:	e8 19 c6 ff ff       	call   80101a10 <iunlockput>
  ip->nlink--;
801053f7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801053fc:	89 1c 24             	mov    %ebx,(%esp)
801053ff:	e8 cc c2 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
80105404:	89 1c 24             	mov    %ebx,(%esp)
80105407:	e8 04 c6 ff ff       	call   80101a10 <iunlockput>
  end_op();
8010540c:	e8 af dc ff ff       	call   801030c0 <end_op>
  return 0;
80105411:	83 c4 10             	add    $0x10,%esp
80105414:	31 c0                	xor    %eax,%eax
}
80105416:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105419:	5b                   	pop    %ebx
8010541a:	5e                   	pop    %esi
8010541b:	5f                   	pop    %edi
8010541c:	5d                   	pop    %ebp
8010541d:	c3                   	ret    
8010541e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105420:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105424:	76 94                	jbe    801053ba <sys_unlink+0xba>
80105426:	be 20 00 00 00       	mov    $0x20,%esi
8010542b:	eb 0b                	jmp    80105438 <sys_unlink+0x138>
8010542d:	8d 76 00             	lea    0x0(%esi),%esi
80105430:	83 c6 10             	add    $0x10,%esi
80105433:	3b 73 58             	cmp    0x58(%ebx),%esi
80105436:	73 82                	jae    801053ba <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105438:	6a 10                	push   $0x10
8010543a:	56                   	push   %esi
8010543b:	57                   	push   %edi
8010543c:	53                   	push   %ebx
8010543d:	e8 4e c6 ff ff       	call   80101a90 <readi>
80105442:	83 c4 10             	add    $0x10,%esp
80105445:	83 f8 10             	cmp    $0x10,%eax
80105448:	75 68                	jne    801054b2 <sys_unlink+0x1b2>
    if(de.inum != 0)
8010544a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010544f:	74 df                	je     80105430 <sys_unlink+0x130>
    iunlockput(ip);
80105451:	83 ec 0c             	sub    $0xc,%esp
80105454:	53                   	push   %ebx
80105455:	e8 b6 c5 ff ff       	call   80101a10 <iunlockput>
    goto bad;
8010545a:	83 c4 10             	add    $0x10,%esp
8010545d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105460:	83 ec 0c             	sub    $0xc,%esp
80105463:	ff 75 b4             	push   -0x4c(%ebp)
80105466:	e8 a5 c5 ff ff       	call   80101a10 <iunlockput>
  end_op();
8010546b:	e8 50 dc ff ff       	call   801030c0 <end_op>
  return -1;
80105470:	83 c4 10             	add    $0x10,%esp
80105473:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105478:	eb 9c                	jmp    80105416 <sys_unlink+0x116>
8010547a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105480:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105483:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105486:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010548b:	50                   	push   %eax
8010548c:	e8 3f c2 ff ff       	call   801016d0 <iupdate>
80105491:	83 c4 10             	add    $0x10,%esp
80105494:	e9 53 ff ff ff       	jmp    801053ec <sys_unlink+0xec>
    return -1;
80105499:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010549e:	e9 73 ff ff ff       	jmp    80105416 <sys_unlink+0x116>
    end_op();
801054a3:	e8 18 dc ff ff       	call   801030c0 <end_op>
    return -1;
801054a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054ad:	e9 64 ff ff ff       	jmp    80105416 <sys_unlink+0x116>
      panic("isdirempty: readi");
801054b2:	83 ec 0c             	sub    $0xc,%esp
801054b5:	68 48 7e 10 80       	push   $0x80107e48
801054ba:	e8 c1 ae ff ff       	call   80100380 <panic>
    panic("unlink: writei");
801054bf:	83 ec 0c             	sub    $0xc,%esp
801054c2:	68 5a 7e 10 80       	push   $0x80107e5a
801054c7:	e8 b4 ae ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
801054cc:	83 ec 0c             	sub    $0xc,%esp
801054cf:	68 36 7e 10 80       	push   $0x80107e36
801054d4:	e8 a7 ae ff ff       	call   80100380 <panic>
801054d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801054e0 <sys_open>:

int
sys_open(void)
{
801054e0:	55                   	push   %ebp
801054e1:	89 e5                	mov    %esp,%ebp
801054e3:	57                   	push   %edi
801054e4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801054e5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801054e8:	53                   	push   %ebx
801054e9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801054ec:	50                   	push   %eax
801054ed:	6a 00                	push   $0x0
801054ef:	e8 dc f7 ff ff       	call   80104cd0 <argstr>
801054f4:	83 c4 10             	add    $0x10,%esp
801054f7:	85 c0                	test   %eax,%eax
801054f9:	0f 88 8e 00 00 00    	js     8010558d <sys_open+0xad>
801054ff:	83 ec 08             	sub    $0x8,%esp
80105502:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105505:	50                   	push   %eax
80105506:	6a 01                	push   $0x1
80105508:	e8 03 f7 ff ff       	call   80104c10 <argint>
8010550d:	83 c4 10             	add    $0x10,%esp
80105510:	85 c0                	test   %eax,%eax
80105512:	78 79                	js     8010558d <sys_open+0xad>
    return -1;

  begin_op();
80105514:	e8 37 db ff ff       	call   80103050 <begin_op>

  if(omode & O_CREATE){
80105519:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010551d:	75 79                	jne    80105598 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010551f:	83 ec 0c             	sub    $0xc,%esp
80105522:	ff 75 e0             	push   -0x20(%ebp)
80105525:	e8 76 cb ff ff       	call   801020a0 <namei>
8010552a:	83 c4 10             	add    $0x10,%esp
8010552d:	89 c6                	mov    %eax,%esi
8010552f:	85 c0                	test   %eax,%eax
80105531:	0f 84 7e 00 00 00    	je     801055b5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105537:	83 ec 0c             	sub    $0xc,%esp
8010553a:	50                   	push   %eax
8010553b:	e8 40 c2 ff ff       	call   80101780 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105540:	83 c4 10             	add    $0x10,%esp
80105543:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105548:	0f 84 c2 00 00 00    	je     80105610 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010554e:	e8 dd b8 ff ff       	call   80100e30 <filealloc>
80105553:	89 c7                	mov    %eax,%edi
80105555:	85 c0                	test   %eax,%eax
80105557:	74 23                	je     8010557c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105559:	e8 02 e7 ff ff       	call   80103c60 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010555e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105560:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105564:	85 d2                	test   %edx,%edx
80105566:	74 60                	je     801055c8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105568:	83 c3 01             	add    $0x1,%ebx
8010556b:	83 fb 10             	cmp    $0x10,%ebx
8010556e:	75 f0                	jne    80105560 <sys_open+0x80>
    if(f)
      fileclose(f);
80105570:	83 ec 0c             	sub    $0xc,%esp
80105573:	57                   	push   %edi
80105574:	e8 77 b9 ff ff       	call   80100ef0 <fileclose>
80105579:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010557c:	83 ec 0c             	sub    $0xc,%esp
8010557f:	56                   	push   %esi
80105580:	e8 8b c4 ff ff       	call   80101a10 <iunlockput>
    end_op();
80105585:	e8 36 db ff ff       	call   801030c0 <end_op>
    return -1;
8010558a:	83 c4 10             	add    $0x10,%esp
8010558d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105592:	eb 6d                	jmp    80105601 <sys_open+0x121>
80105594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105598:	83 ec 0c             	sub    $0xc,%esp
8010559b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010559e:	31 c9                	xor    %ecx,%ecx
801055a0:	ba 02 00 00 00       	mov    $0x2,%edx
801055a5:	6a 00                	push   $0x0
801055a7:	e8 14 f8 ff ff       	call   80104dc0 <create>
    if(ip == 0){
801055ac:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801055af:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801055b1:	85 c0                	test   %eax,%eax
801055b3:	75 99                	jne    8010554e <sys_open+0x6e>
      end_op();
801055b5:	e8 06 db ff ff       	call   801030c0 <end_op>
      return -1;
801055ba:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801055bf:	eb 40                	jmp    80105601 <sys_open+0x121>
801055c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801055c8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801055cb:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801055cf:	56                   	push   %esi
801055d0:	e8 8b c2 ff ff       	call   80101860 <iunlock>
  end_op();
801055d5:	e8 e6 da ff ff       	call   801030c0 <end_op>

  f->type = FD_INODE;
801055da:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801055e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055e3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801055e6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801055e9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801055eb:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801055f2:	f7 d0                	not    %eax
801055f4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055f7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801055fa:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055fd:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105601:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105604:	89 d8                	mov    %ebx,%eax
80105606:	5b                   	pop    %ebx
80105607:	5e                   	pop    %esi
80105608:	5f                   	pop    %edi
80105609:	5d                   	pop    %ebp
8010560a:	c3                   	ret    
8010560b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010560f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105610:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105613:	85 c9                	test   %ecx,%ecx
80105615:	0f 84 33 ff ff ff    	je     8010554e <sys_open+0x6e>
8010561b:	e9 5c ff ff ff       	jmp    8010557c <sys_open+0x9c>

80105620 <sys_mkdir>:

int
sys_mkdir(void)
{
80105620:	55                   	push   %ebp
80105621:	89 e5                	mov    %esp,%ebp
80105623:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105626:	e8 25 da ff ff       	call   80103050 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010562b:	83 ec 08             	sub    $0x8,%esp
8010562e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105631:	50                   	push   %eax
80105632:	6a 00                	push   $0x0
80105634:	e8 97 f6 ff ff       	call   80104cd0 <argstr>
80105639:	83 c4 10             	add    $0x10,%esp
8010563c:	85 c0                	test   %eax,%eax
8010563e:	78 30                	js     80105670 <sys_mkdir+0x50>
80105640:	83 ec 0c             	sub    $0xc,%esp
80105643:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105646:	31 c9                	xor    %ecx,%ecx
80105648:	ba 01 00 00 00       	mov    $0x1,%edx
8010564d:	6a 00                	push   $0x0
8010564f:	e8 6c f7 ff ff       	call   80104dc0 <create>
80105654:	83 c4 10             	add    $0x10,%esp
80105657:	85 c0                	test   %eax,%eax
80105659:	74 15                	je     80105670 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010565b:	83 ec 0c             	sub    $0xc,%esp
8010565e:	50                   	push   %eax
8010565f:	e8 ac c3 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105664:	e8 57 da ff ff       	call   801030c0 <end_op>
  return 0;
80105669:	83 c4 10             	add    $0x10,%esp
8010566c:	31 c0                	xor    %eax,%eax
}
8010566e:	c9                   	leave  
8010566f:	c3                   	ret    
    end_op();
80105670:	e8 4b da ff ff       	call   801030c0 <end_op>
    return -1;
80105675:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010567a:	c9                   	leave  
8010567b:	c3                   	ret    
8010567c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105680 <sys_mknod>:

int
sys_mknod(void)
{
80105680:	55                   	push   %ebp
80105681:	89 e5                	mov    %esp,%ebp
80105683:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105686:	e8 c5 d9 ff ff       	call   80103050 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010568b:	83 ec 08             	sub    $0x8,%esp
8010568e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105691:	50                   	push   %eax
80105692:	6a 00                	push   $0x0
80105694:	e8 37 f6 ff ff       	call   80104cd0 <argstr>
80105699:	83 c4 10             	add    $0x10,%esp
8010569c:	85 c0                	test   %eax,%eax
8010569e:	78 60                	js     80105700 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801056a0:	83 ec 08             	sub    $0x8,%esp
801056a3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056a6:	50                   	push   %eax
801056a7:	6a 01                	push   $0x1
801056a9:	e8 62 f5 ff ff       	call   80104c10 <argint>
  if((argstr(0, &path)) < 0 ||
801056ae:	83 c4 10             	add    $0x10,%esp
801056b1:	85 c0                	test   %eax,%eax
801056b3:	78 4b                	js     80105700 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801056b5:	83 ec 08             	sub    $0x8,%esp
801056b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056bb:	50                   	push   %eax
801056bc:	6a 02                	push   $0x2
801056be:	e8 4d f5 ff ff       	call   80104c10 <argint>
     argint(1, &major) < 0 ||
801056c3:	83 c4 10             	add    $0x10,%esp
801056c6:	85 c0                	test   %eax,%eax
801056c8:	78 36                	js     80105700 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801056ca:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801056ce:	83 ec 0c             	sub    $0xc,%esp
801056d1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801056d5:	ba 03 00 00 00       	mov    $0x3,%edx
801056da:	50                   	push   %eax
801056db:	8b 45 ec             	mov    -0x14(%ebp),%eax
801056de:	e8 dd f6 ff ff       	call   80104dc0 <create>
     argint(2, &minor) < 0 ||
801056e3:	83 c4 10             	add    $0x10,%esp
801056e6:	85 c0                	test   %eax,%eax
801056e8:	74 16                	je     80105700 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801056ea:	83 ec 0c             	sub    $0xc,%esp
801056ed:	50                   	push   %eax
801056ee:	e8 1d c3 ff ff       	call   80101a10 <iunlockput>
  end_op();
801056f3:	e8 c8 d9 ff ff       	call   801030c0 <end_op>
  return 0;
801056f8:	83 c4 10             	add    $0x10,%esp
801056fb:	31 c0                	xor    %eax,%eax
}
801056fd:	c9                   	leave  
801056fe:	c3                   	ret    
801056ff:	90                   	nop
    end_op();
80105700:	e8 bb d9 ff ff       	call   801030c0 <end_op>
    return -1;
80105705:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010570a:	c9                   	leave  
8010570b:	c3                   	ret    
8010570c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105710 <sys_chdir>:

int
sys_chdir(void)
{
80105710:	55                   	push   %ebp
80105711:	89 e5                	mov    %esp,%ebp
80105713:	56                   	push   %esi
80105714:	53                   	push   %ebx
80105715:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105718:	e8 43 e5 ff ff       	call   80103c60 <myproc>
8010571d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010571f:	e8 2c d9 ff ff       	call   80103050 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105724:	83 ec 08             	sub    $0x8,%esp
80105727:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010572a:	50                   	push   %eax
8010572b:	6a 00                	push   $0x0
8010572d:	e8 9e f5 ff ff       	call   80104cd0 <argstr>
80105732:	83 c4 10             	add    $0x10,%esp
80105735:	85 c0                	test   %eax,%eax
80105737:	78 77                	js     801057b0 <sys_chdir+0xa0>
80105739:	83 ec 0c             	sub    $0xc,%esp
8010573c:	ff 75 f4             	push   -0xc(%ebp)
8010573f:	e8 5c c9 ff ff       	call   801020a0 <namei>
80105744:	83 c4 10             	add    $0x10,%esp
80105747:	89 c3                	mov    %eax,%ebx
80105749:	85 c0                	test   %eax,%eax
8010574b:	74 63                	je     801057b0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010574d:	83 ec 0c             	sub    $0xc,%esp
80105750:	50                   	push   %eax
80105751:	e8 2a c0 ff ff       	call   80101780 <ilock>
  if(ip->type != T_DIR){
80105756:	83 c4 10             	add    $0x10,%esp
80105759:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010575e:	75 30                	jne    80105790 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105760:	83 ec 0c             	sub    $0xc,%esp
80105763:	53                   	push   %ebx
80105764:	e8 f7 c0 ff ff       	call   80101860 <iunlock>
  iput(curproc->cwd);
80105769:	58                   	pop    %eax
8010576a:	ff 76 68             	push   0x68(%esi)
8010576d:	e8 3e c1 ff ff       	call   801018b0 <iput>
  end_op();
80105772:	e8 49 d9 ff ff       	call   801030c0 <end_op>
  curproc->cwd = ip;
80105777:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010577a:	83 c4 10             	add    $0x10,%esp
8010577d:	31 c0                	xor    %eax,%eax
}
8010577f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105782:	5b                   	pop    %ebx
80105783:	5e                   	pop    %esi
80105784:	5d                   	pop    %ebp
80105785:	c3                   	ret    
80105786:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010578d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105790:	83 ec 0c             	sub    $0xc,%esp
80105793:	53                   	push   %ebx
80105794:	e8 77 c2 ff ff       	call   80101a10 <iunlockput>
    end_op();
80105799:	e8 22 d9 ff ff       	call   801030c0 <end_op>
    return -1;
8010579e:	83 c4 10             	add    $0x10,%esp
801057a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057a6:	eb d7                	jmp    8010577f <sys_chdir+0x6f>
801057a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057af:	90                   	nop
    end_op();
801057b0:	e8 0b d9 ff ff       	call   801030c0 <end_op>
    return -1;
801057b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057ba:	eb c3                	jmp    8010577f <sys_chdir+0x6f>
801057bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057c0 <sys_exec>:

int
sys_exec(void)
{
801057c0:	55                   	push   %ebp
801057c1:	89 e5                	mov    %esp,%ebp
801057c3:	57                   	push   %edi
801057c4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801057c5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801057cb:	53                   	push   %ebx
801057cc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801057d2:	50                   	push   %eax
801057d3:	6a 00                	push   $0x0
801057d5:	e8 f6 f4 ff ff       	call   80104cd0 <argstr>
801057da:	83 c4 10             	add    $0x10,%esp
801057dd:	85 c0                	test   %eax,%eax
801057df:	0f 88 87 00 00 00    	js     8010586c <sys_exec+0xac>
801057e5:	83 ec 08             	sub    $0x8,%esp
801057e8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801057ee:	50                   	push   %eax
801057ef:	6a 01                	push   $0x1
801057f1:	e8 1a f4 ff ff       	call   80104c10 <argint>
801057f6:	83 c4 10             	add    $0x10,%esp
801057f9:	85 c0                	test   %eax,%eax
801057fb:	78 6f                	js     8010586c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801057fd:	83 ec 04             	sub    $0x4,%esp
80105800:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105806:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105808:	68 80 00 00 00       	push   $0x80
8010580d:	6a 00                	push   $0x0
8010580f:	56                   	push   %esi
80105810:	e8 3b f1 ff ff       	call   80104950 <memset>
80105815:	83 c4 10             	add    $0x10,%esp
80105818:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010581f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105820:	83 ec 08             	sub    $0x8,%esp
80105823:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105829:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105830:	50                   	push   %eax
80105831:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105837:	01 f8                	add    %edi,%eax
80105839:	50                   	push   %eax
8010583a:	e8 41 f3 ff ff       	call   80104b80 <fetchint>
8010583f:	83 c4 10             	add    $0x10,%esp
80105842:	85 c0                	test   %eax,%eax
80105844:	78 26                	js     8010586c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105846:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010584c:	85 c0                	test   %eax,%eax
8010584e:	74 30                	je     80105880 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105850:	83 ec 08             	sub    $0x8,%esp
80105853:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105856:	52                   	push   %edx
80105857:	50                   	push   %eax
80105858:	e8 63 f3 ff ff       	call   80104bc0 <fetchstr>
8010585d:	83 c4 10             	add    $0x10,%esp
80105860:	85 c0                	test   %eax,%eax
80105862:	78 08                	js     8010586c <sys_exec+0xac>
  for(i=0;; i++){
80105864:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105867:	83 fb 20             	cmp    $0x20,%ebx
8010586a:	75 b4                	jne    80105820 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010586c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010586f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105874:	5b                   	pop    %ebx
80105875:	5e                   	pop    %esi
80105876:	5f                   	pop    %edi
80105877:	5d                   	pop    %ebp
80105878:	c3                   	ret    
80105879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105880:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105887:	00 00 00 00 
  return exec(path, argv);
8010588b:	83 ec 08             	sub    $0x8,%esp
8010588e:	56                   	push   %esi
8010588f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105895:	e8 16 b2 ff ff       	call   80100ab0 <exec>
8010589a:	83 c4 10             	add    $0x10,%esp
}
8010589d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058a0:	5b                   	pop    %ebx
801058a1:	5e                   	pop    %esi
801058a2:	5f                   	pop    %edi
801058a3:	5d                   	pop    %ebp
801058a4:	c3                   	ret    
801058a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058b0 <sys_pipe>:

int
sys_pipe(void)
{
801058b0:	55                   	push   %ebp
801058b1:	89 e5                	mov    %esp,%ebp
801058b3:	57                   	push   %edi
801058b4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801058b5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801058b8:	53                   	push   %ebx
801058b9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801058bc:	6a 08                	push   $0x8
801058be:	50                   	push   %eax
801058bf:	6a 00                	push   $0x0
801058c1:	e8 9a f3 ff ff       	call   80104c60 <argptr>
801058c6:	83 c4 10             	add    $0x10,%esp
801058c9:	85 c0                	test   %eax,%eax
801058cb:	78 4a                	js     80105917 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801058cd:	83 ec 08             	sub    $0x8,%esp
801058d0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801058d3:	50                   	push   %eax
801058d4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801058d7:	50                   	push   %eax
801058d8:	e8 43 de ff ff       	call   80103720 <pipealloc>
801058dd:	83 c4 10             	add    $0x10,%esp
801058e0:	85 c0                	test   %eax,%eax
801058e2:	78 33                	js     80105917 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801058e4:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801058e7:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801058e9:	e8 72 e3 ff ff       	call   80103c60 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801058ee:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
801058f0:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801058f4:	85 f6                	test   %esi,%esi
801058f6:	74 28                	je     80105920 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
801058f8:	83 c3 01             	add    $0x1,%ebx
801058fb:	83 fb 10             	cmp    $0x10,%ebx
801058fe:	75 f0                	jne    801058f0 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105900:	83 ec 0c             	sub    $0xc,%esp
80105903:	ff 75 e0             	push   -0x20(%ebp)
80105906:	e8 e5 b5 ff ff       	call   80100ef0 <fileclose>
    fileclose(wf);
8010590b:	58                   	pop    %eax
8010590c:	ff 75 e4             	push   -0x1c(%ebp)
8010590f:	e8 dc b5 ff ff       	call   80100ef0 <fileclose>
    return -1;
80105914:	83 c4 10             	add    $0x10,%esp
80105917:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010591c:	eb 53                	jmp    80105971 <sys_pipe+0xc1>
8010591e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105920:	8d 73 08             	lea    0x8(%ebx),%esi
80105923:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105927:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010592a:	e8 31 e3 ff ff       	call   80103c60 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010592f:	31 d2                	xor    %edx,%edx
80105931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105938:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010593c:	85 c9                	test   %ecx,%ecx
8010593e:	74 20                	je     80105960 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105940:	83 c2 01             	add    $0x1,%edx
80105943:	83 fa 10             	cmp    $0x10,%edx
80105946:	75 f0                	jne    80105938 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105948:	e8 13 e3 ff ff       	call   80103c60 <myproc>
8010594d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105954:	00 
80105955:	eb a9                	jmp    80105900 <sys_pipe+0x50>
80105957:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010595e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105960:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105964:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105967:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105969:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010596c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010596f:	31 c0                	xor    %eax,%eax
}
80105971:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105974:	5b                   	pop    %ebx
80105975:	5e                   	pop    %esi
80105976:	5f                   	pop    %edi
80105977:	5d                   	pop    %ebp
80105978:	c3                   	ret    
80105979:	66 90                	xchg   %ax,%ax
8010597b:	66 90                	xchg   %ax,%ax
8010597d:	66 90                	xchg   %ax,%ax
8010597f:	90                   	nop

80105980 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105980:	e9 7b e4 ff ff       	jmp    80103e00 <fork>
80105985:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010598c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105990 <sys_exit>:
}

int
sys_exit(void)
{
80105990:	55                   	push   %ebp
80105991:	89 e5                	mov    %esp,%ebp
80105993:	83 ec 08             	sub    $0x8,%esp
  exit();
80105996:	e8 e5 e6 ff ff       	call   80104080 <exit>
  return 0;  // not reached
}
8010599b:	31 c0                	xor    %eax,%eax
8010599d:	c9                   	leave  
8010599e:	c3                   	ret    
8010599f:	90                   	nop

801059a0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
801059a0:	e9 0b e8 ff ff       	jmp    801041b0 <wait>
801059a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059b0 <sys_kill>:
}

int
sys_kill(void)
{
801059b0:	55                   	push   %ebp
801059b1:	89 e5                	mov    %esp,%ebp
801059b3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801059b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059b9:	50                   	push   %eax
801059ba:	6a 00                	push   $0x0
801059bc:	e8 4f f2 ff ff       	call   80104c10 <argint>
801059c1:	83 c4 10             	add    $0x10,%esp
801059c4:	85 c0                	test   %eax,%eax
801059c6:	78 18                	js     801059e0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801059c8:	83 ec 0c             	sub    $0xc,%esp
801059cb:	ff 75 f4             	push   -0xc(%ebp)
801059ce:	e8 7d ea ff ff       	call   80104450 <kill>
801059d3:	83 c4 10             	add    $0x10,%esp
}
801059d6:	c9                   	leave  
801059d7:	c3                   	ret    
801059d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059df:	90                   	nop
801059e0:	c9                   	leave  
    return -1;
801059e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059e6:	c3                   	ret    
801059e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059ee:	66 90                	xchg   %ax,%ax

801059f0 <sys_getpid>:

int
sys_getpid(void)
{
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
801059f3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801059f6:	e8 65 e2 ff ff       	call   80103c60 <myproc>
801059fb:	8b 40 10             	mov    0x10(%eax),%eax
}
801059fe:	c9                   	leave  
801059ff:	c3                   	ret    

80105a00 <sys_sbrk>:

int
sys_sbrk(void)
{
80105a00:	55                   	push   %ebp
80105a01:	89 e5                	mov    %esp,%ebp
80105a03:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105a04:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a07:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105a0a:	50                   	push   %eax
80105a0b:	6a 00                	push   $0x0
80105a0d:	e8 fe f1 ff ff       	call   80104c10 <argint>
80105a12:	83 c4 10             	add    $0x10,%esp
80105a15:	85 c0                	test   %eax,%eax
80105a17:	78 27                	js     80105a40 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105a19:	e8 42 e2 ff ff       	call   80103c60 <myproc>
  if(growproc(n) < 0)
80105a1e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105a21:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105a23:	ff 75 f4             	push   -0xc(%ebp)
80105a26:	e8 55 e3 ff ff       	call   80103d80 <growproc>
80105a2b:	83 c4 10             	add    $0x10,%esp
80105a2e:	85 c0                	test   %eax,%eax
80105a30:	78 0e                	js     80105a40 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105a32:	89 d8                	mov    %ebx,%eax
80105a34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a37:	c9                   	leave  
80105a38:	c3                   	ret    
80105a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105a40:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105a45:	eb eb                	jmp    80105a32 <sys_sbrk+0x32>
80105a47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a4e:	66 90                	xchg   %ax,%ax

80105a50 <sys_sleep>:

int
sys_sleep(void)
{
80105a50:	55                   	push   %ebp
80105a51:	89 e5                	mov    %esp,%ebp
80105a53:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105a54:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a57:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105a5a:	50                   	push   %eax
80105a5b:	6a 00                	push   $0x0
80105a5d:	e8 ae f1 ff ff       	call   80104c10 <argint>
80105a62:	83 c4 10             	add    $0x10,%esp
80105a65:	85 c0                	test   %eax,%eax
80105a67:	0f 88 8a 00 00 00    	js     80105af7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105a6d:	83 ec 0c             	sub    $0xc,%esp
80105a70:	68 80 cc 14 80       	push   $0x8014cc80
80105a75:	e8 16 ee ff ff       	call   80104890 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105a7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105a7d:	8b 1d 60 cc 14 80    	mov    0x8014cc60,%ebx
  while(ticks - ticks0 < n){
80105a83:	83 c4 10             	add    $0x10,%esp
80105a86:	85 d2                	test   %edx,%edx
80105a88:	75 27                	jne    80105ab1 <sys_sleep+0x61>
80105a8a:	eb 54                	jmp    80105ae0 <sys_sleep+0x90>
80105a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105a90:	83 ec 08             	sub    $0x8,%esp
80105a93:	68 80 cc 14 80       	push   $0x8014cc80
80105a98:	68 60 cc 14 80       	push   $0x8014cc60
80105a9d:	e8 8e e8 ff ff       	call   80104330 <sleep>
  while(ticks - ticks0 < n){
80105aa2:	a1 60 cc 14 80       	mov    0x8014cc60,%eax
80105aa7:	83 c4 10             	add    $0x10,%esp
80105aaa:	29 d8                	sub    %ebx,%eax
80105aac:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105aaf:	73 2f                	jae    80105ae0 <sys_sleep+0x90>
    if(myproc()->killed){
80105ab1:	e8 aa e1 ff ff       	call   80103c60 <myproc>
80105ab6:	8b 40 24             	mov    0x24(%eax),%eax
80105ab9:	85 c0                	test   %eax,%eax
80105abb:	74 d3                	je     80105a90 <sys_sleep+0x40>
      release(&tickslock);
80105abd:	83 ec 0c             	sub    $0xc,%esp
80105ac0:	68 80 cc 14 80       	push   $0x8014cc80
80105ac5:	e8 66 ed ff ff       	call   80104830 <release>
  }
  release(&tickslock);
  return 0;
}
80105aca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105acd:	83 c4 10             	add    $0x10,%esp
80105ad0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ad5:	c9                   	leave  
80105ad6:	c3                   	ret    
80105ad7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ade:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105ae0:	83 ec 0c             	sub    $0xc,%esp
80105ae3:	68 80 cc 14 80       	push   $0x8014cc80
80105ae8:	e8 43 ed ff ff       	call   80104830 <release>
  return 0;
80105aed:	83 c4 10             	add    $0x10,%esp
80105af0:	31 c0                	xor    %eax,%eax
}
80105af2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105af5:	c9                   	leave  
80105af6:	c3                   	ret    
    return -1;
80105af7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105afc:	eb f4                	jmp    80105af2 <sys_sleep+0xa2>
80105afe:	66 90                	xchg   %ax,%ax

80105b00 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105b00:	55                   	push   %ebp
80105b01:	89 e5                	mov    %esp,%ebp
80105b03:	53                   	push   %ebx
80105b04:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105b07:	68 80 cc 14 80       	push   $0x8014cc80
80105b0c:	e8 7f ed ff ff       	call   80104890 <acquire>
  xticks = ticks;
80105b11:	8b 1d 60 cc 14 80    	mov    0x8014cc60,%ebx
  release(&tickslock);
80105b17:	c7 04 24 80 cc 14 80 	movl   $0x8014cc80,(%esp)
80105b1e:	e8 0d ed ff ff       	call   80104830 <release>
  return xticks;
}
80105b23:	89 d8                	mov    %ebx,%eax
80105b25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b28:	c9                   	leave  
80105b29:	c3                   	ret    

80105b2a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105b2a:	1e                   	push   %ds
  pushl %es
80105b2b:	06                   	push   %es
  pushl %fs
80105b2c:	0f a0                	push   %fs
  pushl %gs
80105b2e:	0f a8                	push   %gs
  pushal
80105b30:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105b31:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105b35:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105b37:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105b39:	54                   	push   %esp
  call trap
80105b3a:	e8 c1 00 00 00       	call   80105c00 <trap>
  addl $4, %esp
80105b3f:	83 c4 04             	add    $0x4,%esp

80105b42 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105b42:	61                   	popa   
  popl %gs
80105b43:	0f a9                	pop    %gs
  popl %fs
80105b45:	0f a1                	pop    %fs
  popl %es
80105b47:	07                   	pop    %es
  popl %ds
80105b48:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105b49:	83 c4 08             	add    $0x8,%esp
  iret
80105b4c:	cf                   	iret   
80105b4d:	66 90                	xchg   %ax,%ax
80105b4f:	90                   	nop

80105b50 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105b50:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105b51:	31 c0                	xor    %eax,%eax
{
80105b53:	89 e5                	mov    %esp,%ebp
80105b55:	83 ec 08             	sub    $0x8,%esp
80105b58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b5f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105b60:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105b67:	c7 04 c5 c2 cc 14 80 	movl   $0x8e000008,-0x7feb333e(,%eax,8)
80105b6e:	08 00 00 8e 
80105b72:	66 89 14 c5 c0 cc 14 	mov    %dx,-0x7feb3340(,%eax,8)
80105b79:	80 
80105b7a:	c1 ea 10             	shr    $0x10,%edx
80105b7d:	66 89 14 c5 c6 cc 14 	mov    %dx,-0x7feb333a(,%eax,8)
80105b84:	80 
  for(i = 0; i < 256; i++)
80105b85:	83 c0 01             	add    $0x1,%eax
80105b88:	3d 00 01 00 00       	cmp    $0x100,%eax
80105b8d:	75 d1                	jne    80105b60 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105b8f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105b92:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105b97:	c7 05 c2 ce 14 80 08 	movl   $0xef000008,0x8014cec2
80105b9e:	00 00 ef 
  initlock(&tickslock, "time");
80105ba1:	68 69 7e 10 80       	push   $0x80107e69
80105ba6:	68 80 cc 14 80       	push   $0x8014cc80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105bab:	66 a3 c0 ce 14 80    	mov    %ax,0x8014cec0
80105bb1:	c1 e8 10             	shr    $0x10,%eax
80105bb4:	66 a3 c6 ce 14 80    	mov    %ax,0x8014cec6
  initlock(&tickslock, "time");
80105bba:	e8 01 eb ff ff       	call   801046c0 <initlock>
}
80105bbf:	83 c4 10             	add    $0x10,%esp
80105bc2:	c9                   	leave  
80105bc3:	c3                   	ret    
80105bc4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bcf:	90                   	nop

80105bd0 <idtinit>:

void
idtinit(void)
{
80105bd0:	55                   	push   %ebp
  pd[0] = size-1;
80105bd1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105bd6:	89 e5                	mov    %esp,%ebp
80105bd8:	83 ec 10             	sub    $0x10,%esp
80105bdb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105bdf:	b8 c0 cc 14 80       	mov    $0x8014ccc0,%eax
80105be4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105be8:	c1 e8 10             	shr    $0x10,%eax
80105beb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105bef:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105bf2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105bf5:	c9                   	leave  
80105bf6:	c3                   	ret    
80105bf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bfe:	66 90                	xchg   %ax,%ax

80105c00 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105c00:	55                   	push   %ebp
80105c01:	89 e5                	mov    %esp,%ebp
80105c03:	57                   	push   %edi
80105c04:	56                   	push   %esi
80105c05:	53                   	push   %ebx
80105c06:	83 ec 1c             	sub    $0x1c,%esp
80105c09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105c0c:	8b 43 30             	mov    0x30(%ebx),%eax
80105c0f:	83 f8 40             	cmp    $0x40,%eax
80105c12:	0f 84 30 01 00 00    	je     80105d48 <trap+0x148>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105c18:	83 e8 0e             	sub    $0xe,%eax
80105c1b:	83 f8 31             	cmp    $0x31,%eax
80105c1e:	0f 87 8c 00 00 00    	ja     80105cb0 <trap+0xb0>
80105c24:	ff 24 85 10 7f 10 80 	jmp    *-0x7fef80f0(,%eax,4)
80105c2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c2f:	90                   	nop
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105c30:	e8 0b e0 ff ff       	call   80103c40 <cpuid>
80105c35:	85 c0                	test   %eax,%eax
80105c37:	0f 84 13 02 00 00    	je     80105e50 <trap+0x250>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80105c3d:	e8 be cf ff ff       	call   80102c00 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c42:	e8 19 e0 ff ff       	call   80103c60 <myproc>
80105c47:	85 c0                	test   %eax,%eax
80105c49:	74 1d                	je     80105c68 <trap+0x68>
80105c4b:	e8 10 e0 ff ff       	call   80103c60 <myproc>
80105c50:	8b 50 24             	mov    0x24(%eax),%edx
80105c53:	85 d2                	test   %edx,%edx
80105c55:	74 11                	je     80105c68 <trap+0x68>
80105c57:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105c5b:	83 e0 03             	and    $0x3,%eax
80105c5e:	66 83 f8 03          	cmp    $0x3,%ax
80105c62:	0f 84 c8 01 00 00    	je     80105e30 <trap+0x230>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105c68:	e8 f3 df ff ff       	call   80103c60 <myproc>
80105c6d:	85 c0                	test   %eax,%eax
80105c6f:	74 0f                	je     80105c80 <trap+0x80>
80105c71:	e8 ea df ff ff       	call   80103c60 <myproc>
80105c76:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105c7a:	0f 84 b0 00 00 00    	je     80105d30 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c80:	e8 db df ff ff       	call   80103c60 <myproc>
80105c85:	85 c0                	test   %eax,%eax
80105c87:	74 1d                	je     80105ca6 <trap+0xa6>
80105c89:	e8 d2 df ff ff       	call   80103c60 <myproc>
80105c8e:	8b 40 24             	mov    0x24(%eax),%eax
80105c91:	85 c0                	test   %eax,%eax
80105c93:	74 11                	je     80105ca6 <trap+0xa6>
80105c95:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105c99:	83 e0 03             	and    $0x3,%eax
80105c9c:	66 83 f8 03          	cmp    $0x3,%ax
80105ca0:	0f 84 cf 00 00 00    	je     80105d75 <trap+0x175>
    exit();
}
80105ca6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ca9:	5b                   	pop    %ebx
80105caa:	5e                   	pop    %esi
80105cab:	5f                   	pop    %edi
80105cac:	5d                   	pop    %ebp
80105cad:	c3                   	ret    
80105cae:	66 90                	xchg   %ax,%ax
    if(myproc() == 0 || (tf->cs&3) == 0){
80105cb0:	e8 ab df ff ff       	call   80103c60 <myproc>
80105cb5:	8b 7b 38             	mov    0x38(%ebx),%edi
80105cb8:	85 c0                	test   %eax,%eax
80105cba:	0f 84 c4 01 00 00    	je     80105e84 <trap+0x284>
80105cc0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105cc4:	0f 84 ba 01 00 00    	je     80105e84 <trap+0x284>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105cca:	0f 20 d1             	mov    %cr2,%ecx
80105ccd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105cd0:	e8 6b df ff ff       	call   80103c40 <cpuid>
80105cd5:	8b 73 30             	mov    0x30(%ebx),%esi
80105cd8:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105cdb:	8b 43 34             	mov    0x34(%ebx),%eax
80105cde:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105ce1:	e8 7a df ff ff       	call   80103c60 <myproc>
80105ce6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105ce9:	e8 72 df ff ff       	call   80103c60 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105cee:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105cf1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105cf4:	51                   	push   %ecx
80105cf5:	57                   	push   %edi
80105cf6:	52                   	push   %edx
80105cf7:	ff 75 e4             	push   -0x1c(%ebp)
80105cfa:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105cfb:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105cfe:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d01:	56                   	push   %esi
80105d02:	ff 70 10             	push   0x10(%eax)
80105d05:	68 cc 7e 10 80       	push   $0x80107ecc
80105d0a:	e8 91 a9 ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
80105d0f:	83 c4 20             	add    $0x20,%esp
80105d12:	e8 49 df ff ff       	call   80103c60 <myproc>
80105d17:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d1e:	e8 3d df ff ff       	call   80103c60 <myproc>
80105d23:	85 c0                	test   %eax,%eax
80105d25:	0f 85 20 ff ff ff    	jne    80105c4b <trap+0x4b>
80105d2b:	e9 38 ff ff ff       	jmp    80105c68 <trap+0x68>
  if(myproc() && myproc()->state == RUNNING &&
80105d30:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105d34:	0f 85 46 ff ff ff    	jne    80105c80 <trap+0x80>
    yield();
80105d3a:	e8 a1 e5 ff ff       	call   801042e0 <yield>
80105d3f:	e9 3c ff ff ff       	jmp    80105c80 <trap+0x80>
80105d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105d48:	e8 13 df ff ff       	call   80103c60 <myproc>
80105d4d:	8b 70 24             	mov    0x24(%eax),%esi
80105d50:	85 f6                	test   %esi,%esi
80105d52:	0f 85 e8 00 00 00    	jne    80105e40 <trap+0x240>
    myproc()->tf = tf;
80105d58:	e8 03 df ff ff       	call   80103c60 <myproc>
80105d5d:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105d60:	e8 eb ef ff ff       	call   80104d50 <syscall>
    if(myproc()->killed)
80105d65:	e8 f6 de ff ff       	call   80103c60 <myproc>
80105d6a:	8b 48 24             	mov    0x24(%eax),%ecx
80105d6d:	85 c9                	test   %ecx,%ecx
80105d6f:	0f 84 31 ff ff ff    	je     80105ca6 <trap+0xa6>
}
80105d75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d78:	5b                   	pop    %ebx
80105d79:	5e                   	pop    %esi
80105d7a:	5f                   	pop    %edi
80105d7b:	5d                   	pop    %ebp
      exit();
80105d7c:	e9 ff e2 ff ff       	jmp    80104080 <exit>
80105d81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105d88:	8b 7b 38             	mov    0x38(%ebx),%edi
80105d8b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105d8f:	e8 ac de ff ff       	call   80103c40 <cpuid>
80105d94:	57                   	push   %edi
80105d95:	56                   	push   %esi
80105d96:	50                   	push   %eax
80105d97:	68 74 7e 10 80       	push   $0x80107e74
80105d9c:	e8 ff a8 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80105da1:	e8 5a ce ff ff       	call   80102c00 <lapiceoi>
    break;
80105da6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105da9:	e8 b2 de ff ff       	call   80103c60 <myproc>
80105dae:	85 c0                	test   %eax,%eax
80105db0:	0f 85 95 fe ff ff    	jne    80105c4b <trap+0x4b>
80105db6:	e9 ad fe ff ff       	jmp    80105c68 <trap+0x68>
80105dbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105dbf:	90                   	nop
    kbdintr();
80105dc0:	e8 fb cc ff ff       	call   80102ac0 <kbdintr>
    lapiceoi();
80105dc5:	e8 36 ce ff ff       	call   80102c00 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105dca:	e8 91 de ff ff       	call   80103c60 <myproc>
80105dcf:	85 c0                	test   %eax,%eax
80105dd1:	0f 85 74 fe ff ff    	jne    80105c4b <trap+0x4b>
80105dd7:	e9 8c fe ff ff       	jmp    80105c68 <trap+0x68>
80105ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105de0:	e8 3b 02 00 00       	call   80106020 <uartintr>
    lapiceoi();
80105de5:	e8 16 ce ff ff       	call   80102c00 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105dea:	e8 71 de ff ff       	call   80103c60 <myproc>
80105def:	85 c0                	test   %eax,%eax
80105df1:	0f 85 54 fe ff ff    	jne    80105c4b <trap+0x4b>
80105df7:	e9 6c fe ff ff       	jmp    80105c68 <trap+0x68>
80105dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105e00:	e8 3b c4 ff ff       	call   80102240 <ideintr>
80105e05:	e9 33 fe ff ff       	jmp    80105c3d <trap+0x3d>
80105e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    CoW_handler();
80105e10:	e8 6b 16 00 00       	call   80107480 <CoW_handler>
    lapiceoi();
80105e15:	e8 e6 cd ff ff       	call   80102c00 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e1a:	e8 41 de ff ff       	call   80103c60 <myproc>
80105e1f:	85 c0                	test   %eax,%eax
80105e21:	0f 85 24 fe ff ff    	jne    80105c4b <trap+0x4b>
80105e27:	e9 3c fe ff ff       	jmp    80105c68 <trap+0x68>
80105e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105e30:	e8 4b e2 ff ff       	call   80104080 <exit>
80105e35:	e9 2e fe ff ff       	jmp    80105c68 <trap+0x68>
80105e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105e40:	e8 3b e2 ff ff       	call   80104080 <exit>
80105e45:	e9 0e ff ff ff       	jmp    80105d58 <trap+0x158>
80105e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105e50:	83 ec 0c             	sub    $0xc,%esp
80105e53:	68 80 cc 14 80       	push   $0x8014cc80
80105e58:	e8 33 ea ff ff       	call   80104890 <acquire>
      wakeup(&ticks);
80105e5d:	c7 04 24 60 cc 14 80 	movl   $0x8014cc60,(%esp)
      ticks++;
80105e64:	83 05 60 cc 14 80 01 	addl   $0x1,0x8014cc60
      wakeup(&ticks);
80105e6b:	e8 80 e5 ff ff       	call   801043f0 <wakeup>
      release(&tickslock);
80105e70:	c7 04 24 80 cc 14 80 	movl   $0x8014cc80,(%esp)
80105e77:	e8 b4 e9 ff ff       	call   80104830 <release>
80105e7c:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105e7f:	e9 b9 fd ff ff       	jmp    80105c3d <trap+0x3d>
80105e84:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105e87:	e8 b4 dd ff ff       	call   80103c40 <cpuid>
80105e8c:	83 ec 0c             	sub    $0xc,%esp
80105e8f:	56                   	push   %esi
80105e90:	57                   	push   %edi
80105e91:	50                   	push   %eax
80105e92:	ff 73 30             	push   0x30(%ebx)
80105e95:	68 98 7e 10 80       	push   $0x80107e98
80105e9a:	e8 01 a8 ff ff       	call   801006a0 <cprintf>
      panic("trap");
80105e9f:	83 c4 14             	add    $0x14,%esp
80105ea2:	68 6e 7e 10 80       	push   $0x80107e6e
80105ea7:	e8 d4 a4 ff ff       	call   80100380 <panic>
80105eac:	66 90                	xchg   %ax,%ax
80105eae:	66 90                	xchg   %ax,%ax

80105eb0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105eb0:	a1 c0 d4 14 80       	mov    0x8014d4c0,%eax
80105eb5:	85 c0                	test   %eax,%eax
80105eb7:	74 17                	je     80105ed0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105eb9:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105ebe:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105ebf:	a8 01                	test   $0x1,%al
80105ec1:	74 0d                	je     80105ed0 <uartgetc+0x20>
80105ec3:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ec8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105ec9:	0f b6 c0             	movzbl %al,%eax
80105ecc:	c3                   	ret    
80105ecd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105ed0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ed5:	c3                   	ret    
80105ed6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105edd:	8d 76 00             	lea    0x0(%esi),%esi

80105ee0 <uartinit>:
{
80105ee0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105ee1:	31 c9                	xor    %ecx,%ecx
80105ee3:	89 c8                	mov    %ecx,%eax
80105ee5:	89 e5                	mov    %esp,%ebp
80105ee7:	57                   	push   %edi
80105ee8:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105eed:	56                   	push   %esi
80105eee:	89 fa                	mov    %edi,%edx
80105ef0:	53                   	push   %ebx
80105ef1:	83 ec 1c             	sub    $0x1c,%esp
80105ef4:	ee                   	out    %al,(%dx)
80105ef5:	be fb 03 00 00       	mov    $0x3fb,%esi
80105efa:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105eff:	89 f2                	mov    %esi,%edx
80105f01:	ee                   	out    %al,(%dx)
80105f02:	b8 0c 00 00 00       	mov    $0xc,%eax
80105f07:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f0c:	ee                   	out    %al,(%dx)
80105f0d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105f12:	89 c8                	mov    %ecx,%eax
80105f14:	89 da                	mov    %ebx,%edx
80105f16:	ee                   	out    %al,(%dx)
80105f17:	b8 03 00 00 00       	mov    $0x3,%eax
80105f1c:	89 f2                	mov    %esi,%edx
80105f1e:	ee                   	out    %al,(%dx)
80105f1f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105f24:	89 c8                	mov    %ecx,%eax
80105f26:	ee                   	out    %al,(%dx)
80105f27:	b8 01 00 00 00       	mov    $0x1,%eax
80105f2c:	89 da                	mov    %ebx,%edx
80105f2e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f2f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f34:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105f35:	3c ff                	cmp    $0xff,%al
80105f37:	74 78                	je     80105fb1 <uartinit+0xd1>
  uart = 1;
80105f39:	c7 05 c0 d4 14 80 01 	movl   $0x1,0x8014d4c0
80105f40:	00 00 00 
80105f43:	89 fa                	mov    %edi,%edx
80105f45:	ec                   	in     (%dx),%al
80105f46:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f4b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105f4c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105f4f:	bf d8 7f 10 80       	mov    $0x80107fd8,%edi
80105f54:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80105f59:	6a 00                	push   $0x0
80105f5b:	6a 04                	push   $0x4
80105f5d:	e8 1e c5 ff ff       	call   80102480 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105f62:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80105f66:	83 c4 10             	add    $0x10,%esp
80105f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80105f70:	a1 c0 d4 14 80       	mov    0x8014d4c0,%eax
80105f75:	bb 80 00 00 00       	mov    $0x80,%ebx
80105f7a:	85 c0                	test   %eax,%eax
80105f7c:	75 14                	jne    80105f92 <uartinit+0xb2>
80105f7e:	eb 23                	jmp    80105fa3 <uartinit+0xc3>
    microdelay(10);
80105f80:	83 ec 0c             	sub    $0xc,%esp
80105f83:	6a 0a                	push   $0xa
80105f85:	e8 96 cc ff ff       	call   80102c20 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105f8a:	83 c4 10             	add    $0x10,%esp
80105f8d:	83 eb 01             	sub    $0x1,%ebx
80105f90:	74 07                	je     80105f99 <uartinit+0xb9>
80105f92:	89 f2                	mov    %esi,%edx
80105f94:	ec                   	in     (%dx),%al
80105f95:	a8 20                	test   $0x20,%al
80105f97:	74 e7                	je     80105f80 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105f99:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80105f9d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105fa2:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80105fa3:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80105fa7:	83 c7 01             	add    $0x1,%edi
80105faa:	88 45 e7             	mov    %al,-0x19(%ebp)
80105fad:	84 c0                	test   %al,%al
80105faf:	75 bf                	jne    80105f70 <uartinit+0x90>
}
80105fb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fb4:	5b                   	pop    %ebx
80105fb5:	5e                   	pop    %esi
80105fb6:	5f                   	pop    %edi
80105fb7:	5d                   	pop    %ebp
80105fb8:	c3                   	ret    
80105fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105fc0 <uartputc>:
  if(!uart)
80105fc0:	a1 c0 d4 14 80       	mov    0x8014d4c0,%eax
80105fc5:	85 c0                	test   %eax,%eax
80105fc7:	74 47                	je     80106010 <uartputc+0x50>
{
80105fc9:	55                   	push   %ebp
80105fca:	89 e5                	mov    %esp,%ebp
80105fcc:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105fcd:	be fd 03 00 00       	mov    $0x3fd,%esi
80105fd2:	53                   	push   %ebx
80105fd3:	bb 80 00 00 00       	mov    $0x80,%ebx
80105fd8:	eb 18                	jmp    80105ff2 <uartputc+0x32>
80105fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80105fe0:	83 ec 0c             	sub    $0xc,%esp
80105fe3:	6a 0a                	push   $0xa
80105fe5:	e8 36 cc ff ff       	call   80102c20 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105fea:	83 c4 10             	add    $0x10,%esp
80105fed:	83 eb 01             	sub    $0x1,%ebx
80105ff0:	74 07                	je     80105ff9 <uartputc+0x39>
80105ff2:	89 f2                	mov    %esi,%edx
80105ff4:	ec                   	in     (%dx),%al
80105ff5:	a8 20                	test   $0x20,%al
80105ff7:	74 e7                	je     80105fe0 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105ff9:	8b 45 08             	mov    0x8(%ebp),%eax
80105ffc:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106001:	ee                   	out    %al,(%dx)
}
80106002:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106005:	5b                   	pop    %ebx
80106006:	5e                   	pop    %esi
80106007:	5d                   	pop    %ebp
80106008:	c3                   	ret    
80106009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106010:	c3                   	ret    
80106011:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106018:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010601f:	90                   	nop

80106020 <uartintr>:

void
uartintr(void)
{
80106020:	55                   	push   %ebp
80106021:	89 e5                	mov    %esp,%ebp
80106023:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106026:	68 b0 5e 10 80       	push   $0x80105eb0
8010602b:	e8 50 a8 ff ff       	call   80100880 <consoleintr>
}
80106030:	83 c4 10             	add    $0x10,%esp
80106033:	c9                   	leave  
80106034:	c3                   	ret    

80106035 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106035:	6a 00                	push   $0x0
  pushl $0
80106037:	6a 00                	push   $0x0
  jmp alltraps
80106039:	e9 ec fa ff ff       	jmp    80105b2a <alltraps>

8010603e <vector1>:
.globl vector1
vector1:
  pushl $0
8010603e:	6a 00                	push   $0x0
  pushl $1
80106040:	6a 01                	push   $0x1
  jmp alltraps
80106042:	e9 e3 fa ff ff       	jmp    80105b2a <alltraps>

80106047 <vector2>:
.globl vector2
vector2:
  pushl $0
80106047:	6a 00                	push   $0x0
  pushl $2
80106049:	6a 02                	push   $0x2
  jmp alltraps
8010604b:	e9 da fa ff ff       	jmp    80105b2a <alltraps>

80106050 <vector3>:
.globl vector3
vector3:
  pushl $0
80106050:	6a 00                	push   $0x0
  pushl $3
80106052:	6a 03                	push   $0x3
  jmp alltraps
80106054:	e9 d1 fa ff ff       	jmp    80105b2a <alltraps>

80106059 <vector4>:
.globl vector4
vector4:
  pushl $0
80106059:	6a 00                	push   $0x0
  pushl $4
8010605b:	6a 04                	push   $0x4
  jmp alltraps
8010605d:	e9 c8 fa ff ff       	jmp    80105b2a <alltraps>

80106062 <vector5>:
.globl vector5
vector5:
  pushl $0
80106062:	6a 00                	push   $0x0
  pushl $5
80106064:	6a 05                	push   $0x5
  jmp alltraps
80106066:	e9 bf fa ff ff       	jmp    80105b2a <alltraps>

8010606b <vector6>:
.globl vector6
vector6:
  pushl $0
8010606b:	6a 00                	push   $0x0
  pushl $6
8010606d:	6a 06                	push   $0x6
  jmp alltraps
8010606f:	e9 b6 fa ff ff       	jmp    80105b2a <alltraps>

80106074 <vector7>:
.globl vector7
vector7:
  pushl $0
80106074:	6a 00                	push   $0x0
  pushl $7
80106076:	6a 07                	push   $0x7
  jmp alltraps
80106078:	e9 ad fa ff ff       	jmp    80105b2a <alltraps>

8010607d <vector8>:
.globl vector8
vector8:
  pushl $8
8010607d:	6a 08                	push   $0x8
  jmp alltraps
8010607f:	e9 a6 fa ff ff       	jmp    80105b2a <alltraps>

80106084 <vector9>:
.globl vector9
vector9:
  pushl $0
80106084:	6a 00                	push   $0x0
  pushl $9
80106086:	6a 09                	push   $0x9
  jmp alltraps
80106088:	e9 9d fa ff ff       	jmp    80105b2a <alltraps>

8010608d <vector10>:
.globl vector10
vector10:
  pushl $10
8010608d:	6a 0a                	push   $0xa
  jmp alltraps
8010608f:	e9 96 fa ff ff       	jmp    80105b2a <alltraps>

80106094 <vector11>:
.globl vector11
vector11:
  pushl $11
80106094:	6a 0b                	push   $0xb
  jmp alltraps
80106096:	e9 8f fa ff ff       	jmp    80105b2a <alltraps>

8010609b <vector12>:
.globl vector12
vector12:
  pushl $12
8010609b:	6a 0c                	push   $0xc
  jmp alltraps
8010609d:	e9 88 fa ff ff       	jmp    80105b2a <alltraps>

801060a2 <vector13>:
.globl vector13
vector13:
  pushl $13
801060a2:	6a 0d                	push   $0xd
  jmp alltraps
801060a4:	e9 81 fa ff ff       	jmp    80105b2a <alltraps>

801060a9 <vector14>:
.globl vector14
vector14:
  pushl $14
801060a9:	6a 0e                	push   $0xe
  jmp alltraps
801060ab:	e9 7a fa ff ff       	jmp    80105b2a <alltraps>

801060b0 <vector15>:
.globl vector15
vector15:
  pushl $0
801060b0:	6a 00                	push   $0x0
  pushl $15
801060b2:	6a 0f                	push   $0xf
  jmp alltraps
801060b4:	e9 71 fa ff ff       	jmp    80105b2a <alltraps>

801060b9 <vector16>:
.globl vector16
vector16:
  pushl $0
801060b9:	6a 00                	push   $0x0
  pushl $16
801060bb:	6a 10                	push   $0x10
  jmp alltraps
801060bd:	e9 68 fa ff ff       	jmp    80105b2a <alltraps>

801060c2 <vector17>:
.globl vector17
vector17:
  pushl $17
801060c2:	6a 11                	push   $0x11
  jmp alltraps
801060c4:	e9 61 fa ff ff       	jmp    80105b2a <alltraps>

801060c9 <vector18>:
.globl vector18
vector18:
  pushl $0
801060c9:	6a 00                	push   $0x0
  pushl $18
801060cb:	6a 12                	push   $0x12
  jmp alltraps
801060cd:	e9 58 fa ff ff       	jmp    80105b2a <alltraps>

801060d2 <vector19>:
.globl vector19
vector19:
  pushl $0
801060d2:	6a 00                	push   $0x0
  pushl $19
801060d4:	6a 13                	push   $0x13
  jmp alltraps
801060d6:	e9 4f fa ff ff       	jmp    80105b2a <alltraps>

801060db <vector20>:
.globl vector20
vector20:
  pushl $0
801060db:	6a 00                	push   $0x0
  pushl $20
801060dd:	6a 14                	push   $0x14
  jmp alltraps
801060df:	e9 46 fa ff ff       	jmp    80105b2a <alltraps>

801060e4 <vector21>:
.globl vector21
vector21:
  pushl $0
801060e4:	6a 00                	push   $0x0
  pushl $21
801060e6:	6a 15                	push   $0x15
  jmp alltraps
801060e8:	e9 3d fa ff ff       	jmp    80105b2a <alltraps>

801060ed <vector22>:
.globl vector22
vector22:
  pushl $0
801060ed:	6a 00                	push   $0x0
  pushl $22
801060ef:	6a 16                	push   $0x16
  jmp alltraps
801060f1:	e9 34 fa ff ff       	jmp    80105b2a <alltraps>

801060f6 <vector23>:
.globl vector23
vector23:
  pushl $0
801060f6:	6a 00                	push   $0x0
  pushl $23
801060f8:	6a 17                	push   $0x17
  jmp alltraps
801060fa:	e9 2b fa ff ff       	jmp    80105b2a <alltraps>

801060ff <vector24>:
.globl vector24
vector24:
  pushl $0
801060ff:	6a 00                	push   $0x0
  pushl $24
80106101:	6a 18                	push   $0x18
  jmp alltraps
80106103:	e9 22 fa ff ff       	jmp    80105b2a <alltraps>

80106108 <vector25>:
.globl vector25
vector25:
  pushl $0
80106108:	6a 00                	push   $0x0
  pushl $25
8010610a:	6a 19                	push   $0x19
  jmp alltraps
8010610c:	e9 19 fa ff ff       	jmp    80105b2a <alltraps>

80106111 <vector26>:
.globl vector26
vector26:
  pushl $0
80106111:	6a 00                	push   $0x0
  pushl $26
80106113:	6a 1a                	push   $0x1a
  jmp alltraps
80106115:	e9 10 fa ff ff       	jmp    80105b2a <alltraps>

8010611a <vector27>:
.globl vector27
vector27:
  pushl $0
8010611a:	6a 00                	push   $0x0
  pushl $27
8010611c:	6a 1b                	push   $0x1b
  jmp alltraps
8010611e:	e9 07 fa ff ff       	jmp    80105b2a <alltraps>

80106123 <vector28>:
.globl vector28
vector28:
  pushl $0
80106123:	6a 00                	push   $0x0
  pushl $28
80106125:	6a 1c                	push   $0x1c
  jmp alltraps
80106127:	e9 fe f9 ff ff       	jmp    80105b2a <alltraps>

8010612c <vector29>:
.globl vector29
vector29:
  pushl $0
8010612c:	6a 00                	push   $0x0
  pushl $29
8010612e:	6a 1d                	push   $0x1d
  jmp alltraps
80106130:	e9 f5 f9 ff ff       	jmp    80105b2a <alltraps>

80106135 <vector30>:
.globl vector30
vector30:
  pushl $0
80106135:	6a 00                	push   $0x0
  pushl $30
80106137:	6a 1e                	push   $0x1e
  jmp alltraps
80106139:	e9 ec f9 ff ff       	jmp    80105b2a <alltraps>

8010613e <vector31>:
.globl vector31
vector31:
  pushl $0
8010613e:	6a 00                	push   $0x0
  pushl $31
80106140:	6a 1f                	push   $0x1f
  jmp alltraps
80106142:	e9 e3 f9 ff ff       	jmp    80105b2a <alltraps>

80106147 <vector32>:
.globl vector32
vector32:
  pushl $0
80106147:	6a 00                	push   $0x0
  pushl $32
80106149:	6a 20                	push   $0x20
  jmp alltraps
8010614b:	e9 da f9 ff ff       	jmp    80105b2a <alltraps>

80106150 <vector33>:
.globl vector33
vector33:
  pushl $0
80106150:	6a 00                	push   $0x0
  pushl $33
80106152:	6a 21                	push   $0x21
  jmp alltraps
80106154:	e9 d1 f9 ff ff       	jmp    80105b2a <alltraps>

80106159 <vector34>:
.globl vector34
vector34:
  pushl $0
80106159:	6a 00                	push   $0x0
  pushl $34
8010615b:	6a 22                	push   $0x22
  jmp alltraps
8010615d:	e9 c8 f9 ff ff       	jmp    80105b2a <alltraps>

80106162 <vector35>:
.globl vector35
vector35:
  pushl $0
80106162:	6a 00                	push   $0x0
  pushl $35
80106164:	6a 23                	push   $0x23
  jmp alltraps
80106166:	e9 bf f9 ff ff       	jmp    80105b2a <alltraps>

8010616b <vector36>:
.globl vector36
vector36:
  pushl $0
8010616b:	6a 00                	push   $0x0
  pushl $36
8010616d:	6a 24                	push   $0x24
  jmp alltraps
8010616f:	e9 b6 f9 ff ff       	jmp    80105b2a <alltraps>

80106174 <vector37>:
.globl vector37
vector37:
  pushl $0
80106174:	6a 00                	push   $0x0
  pushl $37
80106176:	6a 25                	push   $0x25
  jmp alltraps
80106178:	e9 ad f9 ff ff       	jmp    80105b2a <alltraps>

8010617d <vector38>:
.globl vector38
vector38:
  pushl $0
8010617d:	6a 00                	push   $0x0
  pushl $38
8010617f:	6a 26                	push   $0x26
  jmp alltraps
80106181:	e9 a4 f9 ff ff       	jmp    80105b2a <alltraps>

80106186 <vector39>:
.globl vector39
vector39:
  pushl $0
80106186:	6a 00                	push   $0x0
  pushl $39
80106188:	6a 27                	push   $0x27
  jmp alltraps
8010618a:	e9 9b f9 ff ff       	jmp    80105b2a <alltraps>

8010618f <vector40>:
.globl vector40
vector40:
  pushl $0
8010618f:	6a 00                	push   $0x0
  pushl $40
80106191:	6a 28                	push   $0x28
  jmp alltraps
80106193:	e9 92 f9 ff ff       	jmp    80105b2a <alltraps>

80106198 <vector41>:
.globl vector41
vector41:
  pushl $0
80106198:	6a 00                	push   $0x0
  pushl $41
8010619a:	6a 29                	push   $0x29
  jmp alltraps
8010619c:	e9 89 f9 ff ff       	jmp    80105b2a <alltraps>

801061a1 <vector42>:
.globl vector42
vector42:
  pushl $0
801061a1:	6a 00                	push   $0x0
  pushl $42
801061a3:	6a 2a                	push   $0x2a
  jmp alltraps
801061a5:	e9 80 f9 ff ff       	jmp    80105b2a <alltraps>

801061aa <vector43>:
.globl vector43
vector43:
  pushl $0
801061aa:	6a 00                	push   $0x0
  pushl $43
801061ac:	6a 2b                	push   $0x2b
  jmp alltraps
801061ae:	e9 77 f9 ff ff       	jmp    80105b2a <alltraps>

801061b3 <vector44>:
.globl vector44
vector44:
  pushl $0
801061b3:	6a 00                	push   $0x0
  pushl $44
801061b5:	6a 2c                	push   $0x2c
  jmp alltraps
801061b7:	e9 6e f9 ff ff       	jmp    80105b2a <alltraps>

801061bc <vector45>:
.globl vector45
vector45:
  pushl $0
801061bc:	6a 00                	push   $0x0
  pushl $45
801061be:	6a 2d                	push   $0x2d
  jmp alltraps
801061c0:	e9 65 f9 ff ff       	jmp    80105b2a <alltraps>

801061c5 <vector46>:
.globl vector46
vector46:
  pushl $0
801061c5:	6a 00                	push   $0x0
  pushl $46
801061c7:	6a 2e                	push   $0x2e
  jmp alltraps
801061c9:	e9 5c f9 ff ff       	jmp    80105b2a <alltraps>

801061ce <vector47>:
.globl vector47
vector47:
  pushl $0
801061ce:	6a 00                	push   $0x0
  pushl $47
801061d0:	6a 2f                	push   $0x2f
  jmp alltraps
801061d2:	e9 53 f9 ff ff       	jmp    80105b2a <alltraps>

801061d7 <vector48>:
.globl vector48
vector48:
  pushl $0
801061d7:	6a 00                	push   $0x0
  pushl $48
801061d9:	6a 30                	push   $0x30
  jmp alltraps
801061db:	e9 4a f9 ff ff       	jmp    80105b2a <alltraps>

801061e0 <vector49>:
.globl vector49
vector49:
  pushl $0
801061e0:	6a 00                	push   $0x0
  pushl $49
801061e2:	6a 31                	push   $0x31
  jmp alltraps
801061e4:	e9 41 f9 ff ff       	jmp    80105b2a <alltraps>

801061e9 <vector50>:
.globl vector50
vector50:
  pushl $0
801061e9:	6a 00                	push   $0x0
  pushl $50
801061eb:	6a 32                	push   $0x32
  jmp alltraps
801061ed:	e9 38 f9 ff ff       	jmp    80105b2a <alltraps>

801061f2 <vector51>:
.globl vector51
vector51:
  pushl $0
801061f2:	6a 00                	push   $0x0
  pushl $51
801061f4:	6a 33                	push   $0x33
  jmp alltraps
801061f6:	e9 2f f9 ff ff       	jmp    80105b2a <alltraps>

801061fb <vector52>:
.globl vector52
vector52:
  pushl $0
801061fb:	6a 00                	push   $0x0
  pushl $52
801061fd:	6a 34                	push   $0x34
  jmp alltraps
801061ff:	e9 26 f9 ff ff       	jmp    80105b2a <alltraps>

80106204 <vector53>:
.globl vector53
vector53:
  pushl $0
80106204:	6a 00                	push   $0x0
  pushl $53
80106206:	6a 35                	push   $0x35
  jmp alltraps
80106208:	e9 1d f9 ff ff       	jmp    80105b2a <alltraps>

8010620d <vector54>:
.globl vector54
vector54:
  pushl $0
8010620d:	6a 00                	push   $0x0
  pushl $54
8010620f:	6a 36                	push   $0x36
  jmp alltraps
80106211:	e9 14 f9 ff ff       	jmp    80105b2a <alltraps>

80106216 <vector55>:
.globl vector55
vector55:
  pushl $0
80106216:	6a 00                	push   $0x0
  pushl $55
80106218:	6a 37                	push   $0x37
  jmp alltraps
8010621a:	e9 0b f9 ff ff       	jmp    80105b2a <alltraps>

8010621f <vector56>:
.globl vector56
vector56:
  pushl $0
8010621f:	6a 00                	push   $0x0
  pushl $56
80106221:	6a 38                	push   $0x38
  jmp alltraps
80106223:	e9 02 f9 ff ff       	jmp    80105b2a <alltraps>

80106228 <vector57>:
.globl vector57
vector57:
  pushl $0
80106228:	6a 00                	push   $0x0
  pushl $57
8010622a:	6a 39                	push   $0x39
  jmp alltraps
8010622c:	e9 f9 f8 ff ff       	jmp    80105b2a <alltraps>

80106231 <vector58>:
.globl vector58
vector58:
  pushl $0
80106231:	6a 00                	push   $0x0
  pushl $58
80106233:	6a 3a                	push   $0x3a
  jmp alltraps
80106235:	e9 f0 f8 ff ff       	jmp    80105b2a <alltraps>

8010623a <vector59>:
.globl vector59
vector59:
  pushl $0
8010623a:	6a 00                	push   $0x0
  pushl $59
8010623c:	6a 3b                	push   $0x3b
  jmp alltraps
8010623e:	e9 e7 f8 ff ff       	jmp    80105b2a <alltraps>

80106243 <vector60>:
.globl vector60
vector60:
  pushl $0
80106243:	6a 00                	push   $0x0
  pushl $60
80106245:	6a 3c                	push   $0x3c
  jmp alltraps
80106247:	e9 de f8 ff ff       	jmp    80105b2a <alltraps>

8010624c <vector61>:
.globl vector61
vector61:
  pushl $0
8010624c:	6a 00                	push   $0x0
  pushl $61
8010624e:	6a 3d                	push   $0x3d
  jmp alltraps
80106250:	e9 d5 f8 ff ff       	jmp    80105b2a <alltraps>

80106255 <vector62>:
.globl vector62
vector62:
  pushl $0
80106255:	6a 00                	push   $0x0
  pushl $62
80106257:	6a 3e                	push   $0x3e
  jmp alltraps
80106259:	e9 cc f8 ff ff       	jmp    80105b2a <alltraps>

8010625e <vector63>:
.globl vector63
vector63:
  pushl $0
8010625e:	6a 00                	push   $0x0
  pushl $63
80106260:	6a 3f                	push   $0x3f
  jmp alltraps
80106262:	e9 c3 f8 ff ff       	jmp    80105b2a <alltraps>

80106267 <vector64>:
.globl vector64
vector64:
  pushl $0
80106267:	6a 00                	push   $0x0
  pushl $64
80106269:	6a 40                	push   $0x40
  jmp alltraps
8010626b:	e9 ba f8 ff ff       	jmp    80105b2a <alltraps>

80106270 <vector65>:
.globl vector65
vector65:
  pushl $0
80106270:	6a 00                	push   $0x0
  pushl $65
80106272:	6a 41                	push   $0x41
  jmp alltraps
80106274:	e9 b1 f8 ff ff       	jmp    80105b2a <alltraps>

80106279 <vector66>:
.globl vector66
vector66:
  pushl $0
80106279:	6a 00                	push   $0x0
  pushl $66
8010627b:	6a 42                	push   $0x42
  jmp alltraps
8010627d:	e9 a8 f8 ff ff       	jmp    80105b2a <alltraps>

80106282 <vector67>:
.globl vector67
vector67:
  pushl $0
80106282:	6a 00                	push   $0x0
  pushl $67
80106284:	6a 43                	push   $0x43
  jmp alltraps
80106286:	e9 9f f8 ff ff       	jmp    80105b2a <alltraps>

8010628b <vector68>:
.globl vector68
vector68:
  pushl $0
8010628b:	6a 00                	push   $0x0
  pushl $68
8010628d:	6a 44                	push   $0x44
  jmp alltraps
8010628f:	e9 96 f8 ff ff       	jmp    80105b2a <alltraps>

80106294 <vector69>:
.globl vector69
vector69:
  pushl $0
80106294:	6a 00                	push   $0x0
  pushl $69
80106296:	6a 45                	push   $0x45
  jmp alltraps
80106298:	e9 8d f8 ff ff       	jmp    80105b2a <alltraps>

8010629d <vector70>:
.globl vector70
vector70:
  pushl $0
8010629d:	6a 00                	push   $0x0
  pushl $70
8010629f:	6a 46                	push   $0x46
  jmp alltraps
801062a1:	e9 84 f8 ff ff       	jmp    80105b2a <alltraps>

801062a6 <vector71>:
.globl vector71
vector71:
  pushl $0
801062a6:	6a 00                	push   $0x0
  pushl $71
801062a8:	6a 47                	push   $0x47
  jmp alltraps
801062aa:	e9 7b f8 ff ff       	jmp    80105b2a <alltraps>

801062af <vector72>:
.globl vector72
vector72:
  pushl $0
801062af:	6a 00                	push   $0x0
  pushl $72
801062b1:	6a 48                	push   $0x48
  jmp alltraps
801062b3:	e9 72 f8 ff ff       	jmp    80105b2a <alltraps>

801062b8 <vector73>:
.globl vector73
vector73:
  pushl $0
801062b8:	6a 00                	push   $0x0
  pushl $73
801062ba:	6a 49                	push   $0x49
  jmp alltraps
801062bc:	e9 69 f8 ff ff       	jmp    80105b2a <alltraps>

801062c1 <vector74>:
.globl vector74
vector74:
  pushl $0
801062c1:	6a 00                	push   $0x0
  pushl $74
801062c3:	6a 4a                	push   $0x4a
  jmp alltraps
801062c5:	e9 60 f8 ff ff       	jmp    80105b2a <alltraps>

801062ca <vector75>:
.globl vector75
vector75:
  pushl $0
801062ca:	6a 00                	push   $0x0
  pushl $75
801062cc:	6a 4b                	push   $0x4b
  jmp alltraps
801062ce:	e9 57 f8 ff ff       	jmp    80105b2a <alltraps>

801062d3 <vector76>:
.globl vector76
vector76:
  pushl $0
801062d3:	6a 00                	push   $0x0
  pushl $76
801062d5:	6a 4c                	push   $0x4c
  jmp alltraps
801062d7:	e9 4e f8 ff ff       	jmp    80105b2a <alltraps>

801062dc <vector77>:
.globl vector77
vector77:
  pushl $0
801062dc:	6a 00                	push   $0x0
  pushl $77
801062de:	6a 4d                	push   $0x4d
  jmp alltraps
801062e0:	e9 45 f8 ff ff       	jmp    80105b2a <alltraps>

801062e5 <vector78>:
.globl vector78
vector78:
  pushl $0
801062e5:	6a 00                	push   $0x0
  pushl $78
801062e7:	6a 4e                	push   $0x4e
  jmp alltraps
801062e9:	e9 3c f8 ff ff       	jmp    80105b2a <alltraps>

801062ee <vector79>:
.globl vector79
vector79:
  pushl $0
801062ee:	6a 00                	push   $0x0
  pushl $79
801062f0:	6a 4f                	push   $0x4f
  jmp alltraps
801062f2:	e9 33 f8 ff ff       	jmp    80105b2a <alltraps>

801062f7 <vector80>:
.globl vector80
vector80:
  pushl $0
801062f7:	6a 00                	push   $0x0
  pushl $80
801062f9:	6a 50                	push   $0x50
  jmp alltraps
801062fb:	e9 2a f8 ff ff       	jmp    80105b2a <alltraps>

80106300 <vector81>:
.globl vector81
vector81:
  pushl $0
80106300:	6a 00                	push   $0x0
  pushl $81
80106302:	6a 51                	push   $0x51
  jmp alltraps
80106304:	e9 21 f8 ff ff       	jmp    80105b2a <alltraps>

80106309 <vector82>:
.globl vector82
vector82:
  pushl $0
80106309:	6a 00                	push   $0x0
  pushl $82
8010630b:	6a 52                	push   $0x52
  jmp alltraps
8010630d:	e9 18 f8 ff ff       	jmp    80105b2a <alltraps>

80106312 <vector83>:
.globl vector83
vector83:
  pushl $0
80106312:	6a 00                	push   $0x0
  pushl $83
80106314:	6a 53                	push   $0x53
  jmp alltraps
80106316:	e9 0f f8 ff ff       	jmp    80105b2a <alltraps>

8010631b <vector84>:
.globl vector84
vector84:
  pushl $0
8010631b:	6a 00                	push   $0x0
  pushl $84
8010631d:	6a 54                	push   $0x54
  jmp alltraps
8010631f:	e9 06 f8 ff ff       	jmp    80105b2a <alltraps>

80106324 <vector85>:
.globl vector85
vector85:
  pushl $0
80106324:	6a 00                	push   $0x0
  pushl $85
80106326:	6a 55                	push   $0x55
  jmp alltraps
80106328:	e9 fd f7 ff ff       	jmp    80105b2a <alltraps>

8010632d <vector86>:
.globl vector86
vector86:
  pushl $0
8010632d:	6a 00                	push   $0x0
  pushl $86
8010632f:	6a 56                	push   $0x56
  jmp alltraps
80106331:	e9 f4 f7 ff ff       	jmp    80105b2a <alltraps>

80106336 <vector87>:
.globl vector87
vector87:
  pushl $0
80106336:	6a 00                	push   $0x0
  pushl $87
80106338:	6a 57                	push   $0x57
  jmp alltraps
8010633a:	e9 eb f7 ff ff       	jmp    80105b2a <alltraps>

8010633f <vector88>:
.globl vector88
vector88:
  pushl $0
8010633f:	6a 00                	push   $0x0
  pushl $88
80106341:	6a 58                	push   $0x58
  jmp alltraps
80106343:	e9 e2 f7 ff ff       	jmp    80105b2a <alltraps>

80106348 <vector89>:
.globl vector89
vector89:
  pushl $0
80106348:	6a 00                	push   $0x0
  pushl $89
8010634a:	6a 59                	push   $0x59
  jmp alltraps
8010634c:	e9 d9 f7 ff ff       	jmp    80105b2a <alltraps>

80106351 <vector90>:
.globl vector90
vector90:
  pushl $0
80106351:	6a 00                	push   $0x0
  pushl $90
80106353:	6a 5a                	push   $0x5a
  jmp alltraps
80106355:	e9 d0 f7 ff ff       	jmp    80105b2a <alltraps>

8010635a <vector91>:
.globl vector91
vector91:
  pushl $0
8010635a:	6a 00                	push   $0x0
  pushl $91
8010635c:	6a 5b                	push   $0x5b
  jmp alltraps
8010635e:	e9 c7 f7 ff ff       	jmp    80105b2a <alltraps>

80106363 <vector92>:
.globl vector92
vector92:
  pushl $0
80106363:	6a 00                	push   $0x0
  pushl $92
80106365:	6a 5c                	push   $0x5c
  jmp alltraps
80106367:	e9 be f7 ff ff       	jmp    80105b2a <alltraps>

8010636c <vector93>:
.globl vector93
vector93:
  pushl $0
8010636c:	6a 00                	push   $0x0
  pushl $93
8010636e:	6a 5d                	push   $0x5d
  jmp alltraps
80106370:	e9 b5 f7 ff ff       	jmp    80105b2a <alltraps>

80106375 <vector94>:
.globl vector94
vector94:
  pushl $0
80106375:	6a 00                	push   $0x0
  pushl $94
80106377:	6a 5e                	push   $0x5e
  jmp alltraps
80106379:	e9 ac f7 ff ff       	jmp    80105b2a <alltraps>

8010637e <vector95>:
.globl vector95
vector95:
  pushl $0
8010637e:	6a 00                	push   $0x0
  pushl $95
80106380:	6a 5f                	push   $0x5f
  jmp alltraps
80106382:	e9 a3 f7 ff ff       	jmp    80105b2a <alltraps>

80106387 <vector96>:
.globl vector96
vector96:
  pushl $0
80106387:	6a 00                	push   $0x0
  pushl $96
80106389:	6a 60                	push   $0x60
  jmp alltraps
8010638b:	e9 9a f7 ff ff       	jmp    80105b2a <alltraps>

80106390 <vector97>:
.globl vector97
vector97:
  pushl $0
80106390:	6a 00                	push   $0x0
  pushl $97
80106392:	6a 61                	push   $0x61
  jmp alltraps
80106394:	e9 91 f7 ff ff       	jmp    80105b2a <alltraps>

80106399 <vector98>:
.globl vector98
vector98:
  pushl $0
80106399:	6a 00                	push   $0x0
  pushl $98
8010639b:	6a 62                	push   $0x62
  jmp alltraps
8010639d:	e9 88 f7 ff ff       	jmp    80105b2a <alltraps>

801063a2 <vector99>:
.globl vector99
vector99:
  pushl $0
801063a2:	6a 00                	push   $0x0
  pushl $99
801063a4:	6a 63                	push   $0x63
  jmp alltraps
801063a6:	e9 7f f7 ff ff       	jmp    80105b2a <alltraps>

801063ab <vector100>:
.globl vector100
vector100:
  pushl $0
801063ab:	6a 00                	push   $0x0
  pushl $100
801063ad:	6a 64                	push   $0x64
  jmp alltraps
801063af:	e9 76 f7 ff ff       	jmp    80105b2a <alltraps>

801063b4 <vector101>:
.globl vector101
vector101:
  pushl $0
801063b4:	6a 00                	push   $0x0
  pushl $101
801063b6:	6a 65                	push   $0x65
  jmp alltraps
801063b8:	e9 6d f7 ff ff       	jmp    80105b2a <alltraps>

801063bd <vector102>:
.globl vector102
vector102:
  pushl $0
801063bd:	6a 00                	push   $0x0
  pushl $102
801063bf:	6a 66                	push   $0x66
  jmp alltraps
801063c1:	e9 64 f7 ff ff       	jmp    80105b2a <alltraps>

801063c6 <vector103>:
.globl vector103
vector103:
  pushl $0
801063c6:	6a 00                	push   $0x0
  pushl $103
801063c8:	6a 67                	push   $0x67
  jmp alltraps
801063ca:	e9 5b f7 ff ff       	jmp    80105b2a <alltraps>

801063cf <vector104>:
.globl vector104
vector104:
  pushl $0
801063cf:	6a 00                	push   $0x0
  pushl $104
801063d1:	6a 68                	push   $0x68
  jmp alltraps
801063d3:	e9 52 f7 ff ff       	jmp    80105b2a <alltraps>

801063d8 <vector105>:
.globl vector105
vector105:
  pushl $0
801063d8:	6a 00                	push   $0x0
  pushl $105
801063da:	6a 69                	push   $0x69
  jmp alltraps
801063dc:	e9 49 f7 ff ff       	jmp    80105b2a <alltraps>

801063e1 <vector106>:
.globl vector106
vector106:
  pushl $0
801063e1:	6a 00                	push   $0x0
  pushl $106
801063e3:	6a 6a                	push   $0x6a
  jmp alltraps
801063e5:	e9 40 f7 ff ff       	jmp    80105b2a <alltraps>

801063ea <vector107>:
.globl vector107
vector107:
  pushl $0
801063ea:	6a 00                	push   $0x0
  pushl $107
801063ec:	6a 6b                	push   $0x6b
  jmp alltraps
801063ee:	e9 37 f7 ff ff       	jmp    80105b2a <alltraps>

801063f3 <vector108>:
.globl vector108
vector108:
  pushl $0
801063f3:	6a 00                	push   $0x0
  pushl $108
801063f5:	6a 6c                	push   $0x6c
  jmp alltraps
801063f7:	e9 2e f7 ff ff       	jmp    80105b2a <alltraps>

801063fc <vector109>:
.globl vector109
vector109:
  pushl $0
801063fc:	6a 00                	push   $0x0
  pushl $109
801063fe:	6a 6d                	push   $0x6d
  jmp alltraps
80106400:	e9 25 f7 ff ff       	jmp    80105b2a <alltraps>

80106405 <vector110>:
.globl vector110
vector110:
  pushl $0
80106405:	6a 00                	push   $0x0
  pushl $110
80106407:	6a 6e                	push   $0x6e
  jmp alltraps
80106409:	e9 1c f7 ff ff       	jmp    80105b2a <alltraps>

8010640e <vector111>:
.globl vector111
vector111:
  pushl $0
8010640e:	6a 00                	push   $0x0
  pushl $111
80106410:	6a 6f                	push   $0x6f
  jmp alltraps
80106412:	e9 13 f7 ff ff       	jmp    80105b2a <alltraps>

80106417 <vector112>:
.globl vector112
vector112:
  pushl $0
80106417:	6a 00                	push   $0x0
  pushl $112
80106419:	6a 70                	push   $0x70
  jmp alltraps
8010641b:	e9 0a f7 ff ff       	jmp    80105b2a <alltraps>

80106420 <vector113>:
.globl vector113
vector113:
  pushl $0
80106420:	6a 00                	push   $0x0
  pushl $113
80106422:	6a 71                	push   $0x71
  jmp alltraps
80106424:	e9 01 f7 ff ff       	jmp    80105b2a <alltraps>

80106429 <vector114>:
.globl vector114
vector114:
  pushl $0
80106429:	6a 00                	push   $0x0
  pushl $114
8010642b:	6a 72                	push   $0x72
  jmp alltraps
8010642d:	e9 f8 f6 ff ff       	jmp    80105b2a <alltraps>

80106432 <vector115>:
.globl vector115
vector115:
  pushl $0
80106432:	6a 00                	push   $0x0
  pushl $115
80106434:	6a 73                	push   $0x73
  jmp alltraps
80106436:	e9 ef f6 ff ff       	jmp    80105b2a <alltraps>

8010643b <vector116>:
.globl vector116
vector116:
  pushl $0
8010643b:	6a 00                	push   $0x0
  pushl $116
8010643d:	6a 74                	push   $0x74
  jmp alltraps
8010643f:	e9 e6 f6 ff ff       	jmp    80105b2a <alltraps>

80106444 <vector117>:
.globl vector117
vector117:
  pushl $0
80106444:	6a 00                	push   $0x0
  pushl $117
80106446:	6a 75                	push   $0x75
  jmp alltraps
80106448:	e9 dd f6 ff ff       	jmp    80105b2a <alltraps>

8010644d <vector118>:
.globl vector118
vector118:
  pushl $0
8010644d:	6a 00                	push   $0x0
  pushl $118
8010644f:	6a 76                	push   $0x76
  jmp alltraps
80106451:	e9 d4 f6 ff ff       	jmp    80105b2a <alltraps>

80106456 <vector119>:
.globl vector119
vector119:
  pushl $0
80106456:	6a 00                	push   $0x0
  pushl $119
80106458:	6a 77                	push   $0x77
  jmp alltraps
8010645a:	e9 cb f6 ff ff       	jmp    80105b2a <alltraps>

8010645f <vector120>:
.globl vector120
vector120:
  pushl $0
8010645f:	6a 00                	push   $0x0
  pushl $120
80106461:	6a 78                	push   $0x78
  jmp alltraps
80106463:	e9 c2 f6 ff ff       	jmp    80105b2a <alltraps>

80106468 <vector121>:
.globl vector121
vector121:
  pushl $0
80106468:	6a 00                	push   $0x0
  pushl $121
8010646a:	6a 79                	push   $0x79
  jmp alltraps
8010646c:	e9 b9 f6 ff ff       	jmp    80105b2a <alltraps>

80106471 <vector122>:
.globl vector122
vector122:
  pushl $0
80106471:	6a 00                	push   $0x0
  pushl $122
80106473:	6a 7a                	push   $0x7a
  jmp alltraps
80106475:	e9 b0 f6 ff ff       	jmp    80105b2a <alltraps>

8010647a <vector123>:
.globl vector123
vector123:
  pushl $0
8010647a:	6a 00                	push   $0x0
  pushl $123
8010647c:	6a 7b                	push   $0x7b
  jmp alltraps
8010647e:	e9 a7 f6 ff ff       	jmp    80105b2a <alltraps>

80106483 <vector124>:
.globl vector124
vector124:
  pushl $0
80106483:	6a 00                	push   $0x0
  pushl $124
80106485:	6a 7c                	push   $0x7c
  jmp alltraps
80106487:	e9 9e f6 ff ff       	jmp    80105b2a <alltraps>

8010648c <vector125>:
.globl vector125
vector125:
  pushl $0
8010648c:	6a 00                	push   $0x0
  pushl $125
8010648e:	6a 7d                	push   $0x7d
  jmp alltraps
80106490:	e9 95 f6 ff ff       	jmp    80105b2a <alltraps>

80106495 <vector126>:
.globl vector126
vector126:
  pushl $0
80106495:	6a 00                	push   $0x0
  pushl $126
80106497:	6a 7e                	push   $0x7e
  jmp alltraps
80106499:	e9 8c f6 ff ff       	jmp    80105b2a <alltraps>

8010649e <vector127>:
.globl vector127
vector127:
  pushl $0
8010649e:	6a 00                	push   $0x0
  pushl $127
801064a0:	6a 7f                	push   $0x7f
  jmp alltraps
801064a2:	e9 83 f6 ff ff       	jmp    80105b2a <alltraps>

801064a7 <vector128>:
.globl vector128
vector128:
  pushl $0
801064a7:	6a 00                	push   $0x0
  pushl $128
801064a9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801064ae:	e9 77 f6 ff ff       	jmp    80105b2a <alltraps>

801064b3 <vector129>:
.globl vector129
vector129:
  pushl $0
801064b3:	6a 00                	push   $0x0
  pushl $129
801064b5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801064ba:	e9 6b f6 ff ff       	jmp    80105b2a <alltraps>

801064bf <vector130>:
.globl vector130
vector130:
  pushl $0
801064bf:	6a 00                	push   $0x0
  pushl $130
801064c1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801064c6:	e9 5f f6 ff ff       	jmp    80105b2a <alltraps>

801064cb <vector131>:
.globl vector131
vector131:
  pushl $0
801064cb:	6a 00                	push   $0x0
  pushl $131
801064cd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801064d2:	e9 53 f6 ff ff       	jmp    80105b2a <alltraps>

801064d7 <vector132>:
.globl vector132
vector132:
  pushl $0
801064d7:	6a 00                	push   $0x0
  pushl $132
801064d9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801064de:	e9 47 f6 ff ff       	jmp    80105b2a <alltraps>

801064e3 <vector133>:
.globl vector133
vector133:
  pushl $0
801064e3:	6a 00                	push   $0x0
  pushl $133
801064e5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801064ea:	e9 3b f6 ff ff       	jmp    80105b2a <alltraps>

801064ef <vector134>:
.globl vector134
vector134:
  pushl $0
801064ef:	6a 00                	push   $0x0
  pushl $134
801064f1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801064f6:	e9 2f f6 ff ff       	jmp    80105b2a <alltraps>

801064fb <vector135>:
.globl vector135
vector135:
  pushl $0
801064fb:	6a 00                	push   $0x0
  pushl $135
801064fd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106502:	e9 23 f6 ff ff       	jmp    80105b2a <alltraps>

80106507 <vector136>:
.globl vector136
vector136:
  pushl $0
80106507:	6a 00                	push   $0x0
  pushl $136
80106509:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010650e:	e9 17 f6 ff ff       	jmp    80105b2a <alltraps>

80106513 <vector137>:
.globl vector137
vector137:
  pushl $0
80106513:	6a 00                	push   $0x0
  pushl $137
80106515:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010651a:	e9 0b f6 ff ff       	jmp    80105b2a <alltraps>

8010651f <vector138>:
.globl vector138
vector138:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $138
80106521:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106526:	e9 ff f5 ff ff       	jmp    80105b2a <alltraps>

8010652b <vector139>:
.globl vector139
vector139:
  pushl $0
8010652b:	6a 00                	push   $0x0
  pushl $139
8010652d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106532:	e9 f3 f5 ff ff       	jmp    80105b2a <alltraps>

80106537 <vector140>:
.globl vector140
vector140:
  pushl $0
80106537:	6a 00                	push   $0x0
  pushl $140
80106539:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010653e:	e9 e7 f5 ff ff       	jmp    80105b2a <alltraps>

80106543 <vector141>:
.globl vector141
vector141:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $141
80106545:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010654a:	e9 db f5 ff ff       	jmp    80105b2a <alltraps>

8010654f <vector142>:
.globl vector142
vector142:
  pushl $0
8010654f:	6a 00                	push   $0x0
  pushl $142
80106551:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106556:	e9 cf f5 ff ff       	jmp    80105b2a <alltraps>

8010655b <vector143>:
.globl vector143
vector143:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $143
8010655d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106562:	e9 c3 f5 ff ff       	jmp    80105b2a <alltraps>

80106567 <vector144>:
.globl vector144
vector144:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $144
80106569:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010656e:	e9 b7 f5 ff ff       	jmp    80105b2a <alltraps>

80106573 <vector145>:
.globl vector145
vector145:
  pushl $0
80106573:	6a 00                	push   $0x0
  pushl $145
80106575:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010657a:	e9 ab f5 ff ff       	jmp    80105b2a <alltraps>

8010657f <vector146>:
.globl vector146
vector146:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $146
80106581:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106586:	e9 9f f5 ff ff       	jmp    80105b2a <alltraps>

8010658b <vector147>:
.globl vector147
vector147:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $147
8010658d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106592:	e9 93 f5 ff ff       	jmp    80105b2a <alltraps>

80106597 <vector148>:
.globl vector148
vector148:
  pushl $0
80106597:	6a 00                	push   $0x0
  pushl $148
80106599:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010659e:	e9 87 f5 ff ff       	jmp    80105b2a <alltraps>

801065a3 <vector149>:
.globl vector149
vector149:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $149
801065a5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801065aa:	e9 7b f5 ff ff       	jmp    80105b2a <alltraps>

801065af <vector150>:
.globl vector150
vector150:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $150
801065b1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801065b6:	e9 6f f5 ff ff       	jmp    80105b2a <alltraps>

801065bb <vector151>:
.globl vector151
vector151:
  pushl $0
801065bb:	6a 00                	push   $0x0
  pushl $151
801065bd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801065c2:	e9 63 f5 ff ff       	jmp    80105b2a <alltraps>

801065c7 <vector152>:
.globl vector152
vector152:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $152
801065c9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801065ce:	e9 57 f5 ff ff       	jmp    80105b2a <alltraps>

801065d3 <vector153>:
.globl vector153
vector153:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $153
801065d5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801065da:	e9 4b f5 ff ff       	jmp    80105b2a <alltraps>

801065df <vector154>:
.globl vector154
vector154:
  pushl $0
801065df:	6a 00                	push   $0x0
  pushl $154
801065e1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801065e6:	e9 3f f5 ff ff       	jmp    80105b2a <alltraps>

801065eb <vector155>:
.globl vector155
vector155:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $155
801065ed:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801065f2:	e9 33 f5 ff ff       	jmp    80105b2a <alltraps>

801065f7 <vector156>:
.globl vector156
vector156:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $156
801065f9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801065fe:	e9 27 f5 ff ff       	jmp    80105b2a <alltraps>

80106603 <vector157>:
.globl vector157
vector157:
  pushl $0
80106603:	6a 00                	push   $0x0
  pushl $157
80106605:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010660a:	e9 1b f5 ff ff       	jmp    80105b2a <alltraps>

8010660f <vector158>:
.globl vector158
vector158:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $158
80106611:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106616:	e9 0f f5 ff ff       	jmp    80105b2a <alltraps>

8010661b <vector159>:
.globl vector159
vector159:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $159
8010661d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106622:	e9 03 f5 ff ff       	jmp    80105b2a <alltraps>

80106627 <vector160>:
.globl vector160
vector160:
  pushl $0
80106627:	6a 00                	push   $0x0
  pushl $160
80106629:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010662e:	e9 f7 f4 ff ff       	jmp    80105b2a <alltraps>

80106633 <vector161>:
.globl vector161
vector161:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $161
80106635:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010663a:	e9 eb f4 ff ff       	jmp    80105b2a <alltraps>

8010663f <vector162>:
.globl vector162
vector162:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $162
80106641:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106646:	e9 df f4 ff ff       	jmp    80105b2a <alltraps>

8010664b <vector163>:
.globl vector163
vector163:
  pushl $0
8010664b:	6a 00                	push   $0x0
  pushl $163
8010664d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106652:	e9 d3 f4 ff ff       	jmp    80105b2a <alltraps>

80106657 <vector164>:
.globl vector164
vector164:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $164
80106659:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010665e:	e9 c7 f4 ff ff       	jmp    80105b2a <alltraps>

80106663 <vector165>:
.globl vector165
vector165:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $165
80106665:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010666a:	e9 bb f4 ff ff       	jmp    80105b2a <alltraps>

8010666f <vector166>:
.globl vector166
vector166:
  pushl $0
8010666f:	6a 00                	push   $0x0
  pushl $166
80106671:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106676:	e9 af f4 ff ff       	jmp    80105b2a <alltraps>

8010667b <vector167>:
.globl vector167
vector167:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $167
8010667d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106682:	e9 a3 f4 ff ff       	jmp    80105b2a <alltraps>

80106687 <vector168>:
.globl vector168
vector168:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $168
80106689:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010668e:	e9 97 f4 ff ff       	jmp    80105b2a <alltraps>

80106693 <vector169>:
.globl vector169
vector169:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $169
80106695:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010669a:	e9 8b f4 ff ff       	jmp    80105b2a <alltraps>

8010669f <vector170>:
.globl vector170
vector170:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $170
801066a1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801066a6:	e9 7f f4 ff ff       	jmp    80105b2a <alltraps>

801066ab <vector171>:
.globl vector171
vector171:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $171
801066ad:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801066b2:	e9 73 f4 ff ff       	jmp    80105b2a <alltraps>

801066b7 <vector172>:
.globl vector172
vector172:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $172
801066b9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801066be:	e9 67 f4 ff ff       	jmp    80105b2a <alltraps>

801066c3 <vector173>:
.globl vector173
vector173:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $173
801066c5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801066ca:	e9 5b f4 ff ff       	jmp    80105b2a <alltraps>

801066cf <vector174>:
.globl vector174
vector174:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $174
801066d1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801066d6:	e9 4f f4 ff ff       	jmp    80105b2a <alltraps>

801066db <vector175>:
.globl vector175
vector175:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $175
801066dd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801066e2:	e9 43 f4 ff ff       	jmp    80105b2a <alltraps>

801066e7 <vector176>:
.globl vector176
vector176:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $176
801066e9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801066ee:	e9 37 f4 ff ff       	jmp    80105b2a <alltraps>

801066f3 <vector177>:
.globl vector177
vector177:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $177
801066f5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801066fa:	e9 2b f4 ff ff       	jmp    80105b2a <alltraps>

801066ff <vector178>:
.globl vector178
vector178:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $178
80106701:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106706:	e9 1f f4 ff ff       	jmp    80105b2a <alltraps>

8010670b <vector179>:
.globl vector179
vector179:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $179
8010670d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106712:	e9 13 f4 ff ff       	jmp    80105b2a <alltraps>

80106717 <vector180>:
.globl vector180
vector180:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $180
80106719:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010671e:	e9 07 f4 ff ff       	jmp    80105b2a <alltraps>

80106723 <vector181>:
.globl vector181
vector181:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $181
80106725:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010672a:	e9 fb f3 ff ff       	jmp    80105b2a <alltraps>

8010672f <vector182>:
.globl vector182
vector182:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $182
80106731:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106736:	e9 ef f3 ff ff       	jmp    80105b2a <alltraps>

8010673b <vector183>:
.globl vector183
vector183:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $183
8010673d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106742:	e9 e3 f3 ff ff       	jmp    80105b2a <alltraps>

80106747 <vector184>:
.globl vector184
vector184:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $184
80106749:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010674e:	e9 d7 f3 ff ff       	jmp    80105b2a <alltraps>

80106753 <vector185>:
.globl vector185
vector185:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $185
80106755:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010675a:	e9 cb f3 ff ff       	jmp    80105b2a <alltraps>

8010675f <vector186>:
.globl vector186
vector186:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $186
80106761:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106766:	e9 bf f3 ff ff       	jmp    80105b2a <alltraps>

8010676b <vector187>:
.globl vector187
vector187:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $187
8010676d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106772:	e9 b3 f3 ff ff       	jmp    80105b2a <alltraps>

80106777 <vector188>:
.globl vector188
vector188:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $188
80106779:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010677e:	e9 a7 f3 ff ff       	jmp    80105b2a <alltraps>

80106783 <vector189>:
.globl vector189
vector189:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $189
80106785:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010678a:	e9 9b f3 ff ff       	jmp    80105b2a <alltraps>

8010678f <vector190>:
.globl vector190
vector190:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $190
80106791:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106796:	e9 8f f3 ff ff       	jmp    80105b2a <alltraps>

8010679b <vector191>:
.globl vector191
vector191:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $191
8010679d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801067a2:	e9 83 f3 ff ff       	jmp    80105b2a <alltraps>

801067a7 <vector192>:
.globl vector192
vector192:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $192
801067a9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801067ae:	e9 77 f3 ff ff       	jmp    80105b2a <alltraps>

801067b3 <vector193>:
.globl vector193
vector193:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $193
801067b5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801067ba:	e9 6b f3 ff ff       	jmp    80105b2a <alltraps>

801067bf <vector194>:
.globl vector194
vector194:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $194
801067c1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801067c6:	e9 5f f3 ff ff       	jmp    80105b2a <alltraps>

801067cb <vector195>:
.globl vector195
vector195:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $195
801067cd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801067d2:	e9 53 f3 ff ff       	jmp    80105b2a <alltraps>

801067d7 <vector196>:
.globl vector196
vector196:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $196
801067d9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801067de:	e9 47 f3 ff ff       	jmp    80105b2a <alltraps>

801067e3 <vector197>:
.globl vector197
vector197:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $197
801067e5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801067ea:	e9 3b f3 ff ff       	jmp    80105b2a <alltraps>

801067ef <vector198>:
.globl vector198
vector198:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $198
801067f1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801067f6:	e9 2f f3 ff ff       	jmp    80105b2a <alltraps>

801067fb <vector199>:
.globl vector199
vector199:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $199
801067fd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106802:	e9 23 f3 ff ff       	jmp    80105b2a <alltraps>

80106807 <vector200>:
.globl vector200
vector200:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $200
80106809:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010680e:	e9 17 f3 ff ff       	jmp    80105b2a <alltraps>

80106813 <vector201>:
.globl vector201
vector201:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $201
80106815:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010681a:	e9 0b f3 ff ff       	jmp    80105b2a <alltraps>

8010681f <vector202>:
.globl vector202
vector202:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $202
80106821:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106826:	e9 ff f2 ff ff       	jmp    80105b2a <alltraps>

8010682b <vector203>:
.globl vector203
vector203:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $203
8010682d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106832:	e9 f3 f2 ff ff       	jmp    80105b2a <alltraps>

80106837 <vector204>:
.globl vector204
vector204:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $204
80106839:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010683e:	e9 e7 f2 ff ff       	jmp    80105b2a <alltraps>

80106843 <vector205>:
.globl vector205
vector205:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $205
80106845:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010684a:	e9 db f2 ff ff       	jmp    80105b2a <alltraps>

8010684f <vector206>:
.globl vector206
vector206:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $206
80106851:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106856:	e9 cf f2 ff ff       	jmp    80105b2a <alltraps>

8010685b <vector207>:
.globl vector207
vector207:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $207
8010685d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106862:	e9 c3 f2 ff ff       	jmp    80105b2a <alltraps>

80106867 <vector208>:
.globl vector208
vector208:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $208
80106869:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010686e:	e9 b7 f2 ff ff       	jmp    80105b2a <alltraps>

80106873 <vector209>:
.globl vector209
vector209:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $209
80106875:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010687a:	e9 ab f2 ff ff       	jmp    80105b2a <alltraps>

8010687f <vector210>:
.globl vector210
vector210:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $210
80106881:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106886:	e9 9f f2 ff ff       	jmp    80105b2a <alltraps>

8010688b <vector211>:
.globl vector211
vector211:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $211
8010688d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106892:	e9 93 f2 ff ff       	jmp    80105b2a <alltraps>

80106897 <vector212>:
.globl vector212
vector212:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $212
80106899:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010689e:	e9 87 f2 ff ff       	jmp    80105b2a <alltraps>

801068a3 <vector213>:
.globl vector213
vector213:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $213
801068a5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801068aa:	e9 7b f2 ff ff       	jmp    80105b2a <alltraps>

801068af <vector214>:
.globl vector214
vector214:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $214
801068b1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801068b6:	e9 6f f2 ff ff       	jmp    80105b2a <alltraps>

801068bb <vector215>:
.globl vector215
vector215:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $215
801068bd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801068c2:	e9 63 f2 ff ff       	jmp    80105b2a <alltraps>

801068c7 <vector216>:
.globl vector216
vector216:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $216
801068c9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801068ce:	e9 57 f2 ff ff       	jmp    80105b2a <alltraps>

801068d3 <vector217>:
.globl vector217
vector217:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $217
801068d5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801068da:	e9 4b f2 ff ff       	jmp    80105b2a <alltraps>

801068df <vector218>:
.globl vector218
vector218:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $218
801068e1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801068e6:	e9 3f f2 ff ff       	jmp    80105b2a <alltraps>

801068eb <vector219>:
.globl vector219
vector219:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $219
801068ed:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801068f2:	e9 33 f2 ff ff       	jmp    80105b2a <alltraps>

801068f7 <vector220>:
.globl vector220
vector220:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $220
801068f9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801068fe:	e9 27 f2 ff ff       	jmp    80105b2a <alltraps>

80106903 <vector221>:
.globl vector221
vector221:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $221
80106905:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010690a:	e9 1b f2 ff ff       	jmp    80105b2a <alltraps>

8010690f <vector222>:
.globl vector222
vector222:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $222
80106911:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106916:	e9 0f f2 ff ff       	jmp    80105b2a <alltraps>

8010691b <vector223>:
.globl vector223
vector223:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $223
8010691d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106922:	e9 03 f2 ff ff       	jmp    80105b2a <alltraps>

80106927 <vector224>:
.globl vector224
vector224:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $224
80106929:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010692e:	e9 f7 f1 ff ff       	jmp    80105b2a <alltraps>

80106933 <vector225>:
.globl vector225
vector225:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $225
80106935:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010693a:	e9 eb f1 ff ff       	jmp    80105b2a <alltraps>

8010693f <vector226>:
.globl vector226
vector226:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $226
80106941:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106946:	e9 df f1 ff ff       	jmp    80105b2a <alltraps>

8010694b <vector227>:
.globl vector227
vector227:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $227
8010694d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106952:	e9 d3 f1 ff ff       	jmp    80105b2a <alltraps>

80106957 <vector228>:
.globl vector228
vector228:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $228
80106959:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010695e:	e9 c7 f1 ff ff       	jmp    80105b2a <alltraps>

80106963 <vector229>:
.globl vector229
vector229:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $229
80106965:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010696a:	e9 bb f1 ff ff       	jmp    80105b2a <alltraps>

8010696f <vector230>:
.globl vector230
vector230:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $230
80106971:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106976:	e9 af f1 ff ff       	jmp    80105b2a <alltraps>

8010697b <vector231>:
.globl vector231
vector231:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $231
8010697d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106982:	e9 a3 f1 ff ff       	jmp    80105b2a <alltraps>

80106987 <vector232>:
.globl vector232
vector232:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $232
80106989:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010698e:	e9 97 f1 ff ff       	jmp    80105b2a <alltraps>

80106993 <vector233>:
.globl vector233
vector233:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $233
80106995:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010699a:	e9 8b f1 ff ff       	jmp    80105b2a <alltraps>

8010699f <vector234>:
.globl vector234
vector234:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $234
801069a1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801069a6:	e9 7f f1 ff ff       	jmp    80105b2a <alltraps>

801069ab <vector235>:
.globl vector235
vector235:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $235
801069ad:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801069b2:	e9 73 f1 ff ff       	jmp    80105b2a <alltraps>

801069b7 <vector236>:
.globl vector236
vector236:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $236
801069b9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801069be:	e9 67 f1 ff ff       	jmp    80105b2a <alltraps>

801069c3 <vector237>:
.globl vector237
vector237:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $237
801069c5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801069ca:	e9 5b f1 ff ff       	jmp    80105b2a <alltraps>

801069cf <vector238>:
.globl vector238
vector238:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $238
801069d1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801069d6:	e9 4f f1 ff ff       	jmp    80105b2a <alltraps>

801069db <vector239>:
.globl vector239
vector239:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $239
801069dd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801069e2:	e9 43 f1 ff ff       	jmp    80105b2a <alltraps>

801069e7 <vector240>:
.globl vector240
vector240:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $240
801069e9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801069ee:	e9 37 f1 ff ff       	jmp    80105b2a <alltraps>

801069f3 <vector241>:
.globl vector241
vector241:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $241
801069f5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801069fa:	e9 2b f1 ff ff       	jmp    80105b2a <alltraps>

801069ff <vector242>:
.globl vector242
vector242:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $242
80106a01:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106a06:	e9 1f f1 ff ff       	jmp    80105b2a <alltraps>

80106a0b <vector243>:
.globl vector243
vector243:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $243
80106a0d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106a12:	e9 13 f1 ff ff       	jmp    80105b2a <alltraps>

80106a17 <vector244>:
.globl vector244
vector244:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $244
80106a19:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106a1e:	e9 07 f1 ff ff       	jmp    80105b2a <alltraps>

80106a23 <vector245>:
.globl vector245
vector245:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $245
80106a25:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106a2a:	e9 fb f0 ff ff       	jmp    80105b2a <alltraps>

80106a2f <vector246>:
.globl vector246
vector246:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $246
80106a31:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106a36:	e9 ef f0 ff ff       	jmp    80105b2a <alltraps>

80106a3b <vector247>:
.globl vector247
vector247:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $247
80106a3d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106a42:	e9 e3 f0 ff ff       	jmp    80105b2a <alltraps>

80106a47 <vector248>:
.globl vector248
vector248:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $248
80106a49:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106a4e:	e9 d7 f0 ff ff       	jmp    80105b2a <alltraps>

80106a53 <vector249>:
.globl vector249
vector249:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $249
80106a55:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106a5a:	e9 cb f0 ff ff       	jmp    80105b2a <alltraps>

80106a5f <vector250>:
.globl vector250
vector250:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $250
80106a61:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106a66:	e9 bf f0 ff ff       	jmp    80105b2a <alltraps>

80106a6b <vector251>:
.globl vector251
vector251:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $251
80106a6d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106a72:	e9 b3 f0 ff ff       	jmp    80105b2a <alltraps>

80106a77 <vector252>:
.globl vector252
vector252:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $252
80106a79:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106a7e:	e9 a7 f0 ff ff       	jmp    80105b2a <alltraps>

80106a83 <vector253>:
.globl vector253
vector253:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $253
80106a85:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106a8a:	e9 9b f0 ff ff       	jmp    80105b2a <alltraps>

80106a8f <vector254>:
.globl vector254
vector254:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $254
80106a91:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106a96:	e9 8f f0 ff ff       	jmp    80105b2a <alltraps>

80106a9b <vector255>:
.globl vector255
vector255:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $255
80106a9d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106aa2:	e9 83 f0 ff ff       	jmp    80105b2a <alltraps>
80106aa7:	66 90                	xchg   %ax,%ax
80106aa9:	66 90                	xchg   %ax,%ax
80106aab:	66 90                	xchg   %ax,%ax
80106aad:	66 90                	xchg   %ax,%ax
80106aaf:	90                   	nop

80106ab0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106ab0:	55                   	push   %ebp
80106ab1:	89 e5                	mov    %esp,%ebp
80106ab3:	57                   	push   %edi
80106ab4:	56                   	push   %esi
80106ab5:	89 c6                	mov    %eax,%esi
80106ab7:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106ab8:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106abe:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106ac4:	83 ec 1c             	sub    $0x1c,%esp
80106ac7:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106aca:	39 d3                	cmp    %edx,%ebx
80106acc:	73 79                	jae    80106b47 <deallocuvm.part.0+0x97>
80106ace:	89 d7                	mov    %edx,%edi
80106ad0:	eb 12                	jmp    80106ae4 <deallocuvm.part.0+0x34>
80106ad2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106ad8:	83 c0 01             	add    $0x1,%eax
80106adb:	c1 e0 16             	shl    $0x16,%eax
80106ade:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106ae0:	39 df                	cmp    %ebx,%edi
80106ae2:	76 63                	jbe    80106b47 <deallocuvm.part.0+0x97>
  pde = &pgdir[PDX(va)];
80106ae4:	89 d8                	mov    %ebx,%eax
80106ae6:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106ae9:	8b 14 86             	mov    (%esi,%eax,4),%edx
80106aec:	f6 c2 01             	test   $0x1,%dl
80106aef:	74 e7                	je     80106ad8 <deallocuvm.part.0+0x28>
  return &pgtab[PTX(va)];
80106af1:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106af3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80106af9:	c1 e9 0a             	shr    $0xa,%ecx
80106afc:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80106b02:	8d 94 0a 00 00 00 80 	lea    -0x80000000(%edx,%ecx,1),%edx
    if(!pte)
80106b09:	85 d2                	test   %edx,%edx
80106b0b:	74 cb                	je     80106ad8 <deallocuvm.part.0+0x28>
    else if((*pte & PTE_P) != 0){
80106b0d:	8b 02                	mov    (%edx),%eax
80106b0f:	a8 01                	test   $0x1,%al
80106b11:	74 2a                	je     80106b3d <deallocuvm.part.0+0x8d>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106b13:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106b18:	74 58                	je     80106b72 <deallocuvm.part.0+0xc2>
        panic("kfree");
      char *v = P2V(pa);
      if (get_refc(pa) == 1)
80106b1a:	83 ec 0c             	sub    $0xc,%esp
80106b1d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80106b20:	50                   	push   %eax
80106b21:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106b24:	e8 c7 bd ff ff       	call   801028f0 <get_refc>
80106b29:	83 c4 10             	add    $0x10,%esp
80106b2c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106b2f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80106b32:	83 f8 01             	cmp    $0x1,%eax
80106b35:	74 21                	je     80106b58 <deallocuvm.part.0+0xa8>
        kfree(v);
      *pte = 0;
80106b37:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  for(; a  < oldsz; a += PGSIZE){
80106b3d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b43:	39 df                	cmp    %ebx,%edi
80106b45:	77 9d                	ja     80106ae4 <deallocuvm.part.0+0x34>
    }
  }
  return newsz;
}
80106b47:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106b4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b4d:	5b                   	pop    %ebx
80106b4e:	5e                   	pop    %esi
80106b4f:	5f                   	pop    %edi
80106b50:	5d                   	pop    %ebp
80106b51:	c3                   	ret    
80106b52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(v);
80106b58:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106b5b:	8d 81 00 00 00 80    	lea    -0x80000000(%ecx),%eax
80106b61:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        kfree(v);
80106b64:	50                   	push   %eax
80106b65:	e8 56 b9 ff ff       	call   801024c0 <kfree>
80106b6a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106b6d:	83 c4 10             	add    $0x10,%esp
80106b70:	eb c5                	jmp    80106b37 <deallocuvm.part.0+0x87>
        panic("kfree");
80106b72:	83 ec 0c             	sub    $0xc,%esp
80106b75:	68 26 79 10 80       	push   $0x80107926
80106b7a:	e8 01 98 ff ff       	call   80100380 <panic>
80106b7f:	90                   	nop

80106b80 <mappages>:
{
80106b80:	55                   	push   %ebp
80106b81:	89 e5                	mov    %esp,%ebp
80106b83:	57                   	push   %edi
80106b84:	56                   	push   %esi
80106b85:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106b86:	89 d3                	mov    %edx,%ebx
80106b88:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106b8e:	83 ec 1c             	sub    $0x1c,%esp
80106b91:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106b94:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106b98:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106b9d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106ba0:	8b 45 08             	mov    0x8(%ebp),%eax
80106ba3:	29 d8                	sub    %ebx,%eax
80106ba5:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106ba8:	eb 3d                	jmp    80106be7 <mappages+0x67>
80106baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106bb0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106bb2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106bb7:	c1 ea 0a             	shr    $0xa,%edx
80106bba:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106bc0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106bc7:	85 c0                	test   %eax,%eax
80106bc9:	74 75                	je     80106c40 <mappages+0xc0>
    if(*pte & PTE_P)
80106bcb:	f6 00 01             	testb  $0x1,(%eax)
80106bce:	0f 85 86 00 00 00    	jne    80106c5a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106bd4:	0b 75 0c             	or     0xc(%ebp),%esi
80106bd7:	83 ce 01             	or     $0x1,%esi
80106bda:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106bdc:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
80106bdf:	74 6f                	je     80106c50 <mappages+0xd0>
    a += PGSIZE;
80106be1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106be7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106bea:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106bed:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80106bf0:	89 d8                	mov    %ebx,%eax
80106bf2:	c1 e8 16             	shr    $0x16,%eax
80106bf5:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106bf8:	8b 07                	mov    (%edi),%eax
80106bfa:	a8 01                	test   $0x1,%al
80106bfc:	75 b2                	jne    80106bb0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106bfe:	e8 1d bb ff ff       	call   80102720 <kalloc>
80106c03:	85 c0                	test   %eax,%eax
80106c05:	74 39                	je     80106c40 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106c07:	83 ec 04             	sub    $0x4,%esp
80106c0a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106c0d:	68 00 10 00 00       	push   $0x1000
80106c12:	6a 00                	push   $0x0
80106c14:	50                   	push   %eax
80106c15:	e8 36 dd ff ff       	call   80104950 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106c1a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106c1d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106c20:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106c26:	83 c8 07             	or     $0x7,%eax
80106c29:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106c2b:	89 d8                	mov    %ebx,%eax
80106c2d:	c1 e8 0a             	shr    $0xa,%eax
80106c30:	25 fc 0f 00 00       	and    $0xffc,%eax
80106c35:	01 d0                	add    %edx,%eax
80106c37:	eb 92                	jmp    80106bcb <mappages+0x4b>
80106c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80106c40:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106c43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106c48:	5b                   	pop    %ebx
80106c49:	5e                   	pop    %esi
80106c4a:	5f                   	pop    %edi
80106c4b:	5d                   	pop    %ebp
80106c4c:	c3                   	ret    
80106c4d:	8d 76 00             	lea    0x0(%esi),%esi
80106c50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106c53:	31 c0                	xor    %eax,%eax
}
80106c55:	5b                   	pop    %ebx
80106c56:	5e                   	pop    %esi
80106c57:	5f                   	pop    %edi
80106c58:	5d                   	pop    %ebp
80106c59:	c3                   	ret    
      panic("remap");
80106c5a:	83 ec 0c             	sub    $0xc,%esp
80106c5d:	68 e0 7f 10 80       	push   $0x80107fe0
80106c62:	e8 19 97 ff ff       	call   80100380 <panic>
80106c67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c6e:	66 90                	xchg   %ax,%ax

80106c70 <seginit>:
{
80106c70:	55                   	push   %ebp
80106c71:	89 e5                	mov    %esp,%ebp
80106c73:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106c76:	e8 c5 cf ff ff       	call   80103c40 <cpuid>
  pd[0] = size-1;
80106c7b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106c80:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106c86:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106c8a:	c7 80 18 a8 14 80 ff 	movl   $0xffff,-0x7feb57e8(%eax)
80106c91:	ff 00 00 
80106c94:	c7 80 1c a8 14 80 00 	movl   $0xcf9a00,-0x7feb57e4(%eax)
80106c9b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106c9e:	c7 80 20 a8 14 80 ff 	movl   $0xffff,-0x7feb57e0(%eax)
80106ca5:	ff 00 00 
80106ca8:	c7 80 24 a8 14 80 00 	movl   $0xcf9200,-0x7feb57dc(%eax)
80106caf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106cb2:	c7 80 28 a8 14 80 ff 	movl   $0xffff,-0x7feb57d8(%eax)
80106cb9:	ff 00 00 
80106cbc:	c7 80 2c a8 14 80 00 	movl   $0xcffa00,-0x7feb57d4(%eax)
80106cc3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106cc6:	c7 80 30 a8 14 80 ff 	movl   $0xffff,-0x7feb57d0(%eax)
80106ccd:	ff 00 00 
80106cd0:	c7 80 34 a8 14 80 00 	movl   $0xcff200,-0x7feb57cc(%eax)
80106cd7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106cda:	05 10 a8 14 80       	add    $0x8014a810,%eax
  pd[1] = (uint)p;
80106cdf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106ce3:	c1 e8 10             	shr    $0x10,%eax
80106ce6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106cea:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106ced:	0f 01 10             	lgdtl  (%eax)
}
80106cf0:	c9                   	leave  
80106cf1:	c3                   	ret    
80106cf2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106d00 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106d00:	a1 c4 d4 14 80       	mov    0x8014d4c4,%eax
80106d05:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106d0a:	0f 22 d8             	mov    %eax,%cr3
}
80106d0d:	c3                   	ret    
80106d0e:	66 90                	xchg   %ax,%ax

80106d10 <switchuvm>:
{
80106d10:	55                   	push   %ebp
80106d11:	89 e5                	mov    %esp,%ebp
80106d13:	57                   	push   %edi
80106d14:	56                   	push   %esi
80106d15:	53                   	push   %ebx
80106d16:	83 ec 1c             	sub    $0x1c,%esp
80106d19:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106d1c:	85 f6                	test   %esi,%esi
80106d1e:	0f 84 cb 00 00 00    	je     80106def <switchuvm+0xdf>
  if(p->kstack == 0)
80106d24:	8b 46 08             	mov    0x8(%esi),%eax
80106d27:	85 c0                	test   %eax,%eax
80106d29:	0f 84 da 00 00 00    	je     80106e09 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106d2f:	8b 46 04             	mov    0x4(%esi),%eax
80106d32:	85 c0                	test   %eax,%eax
80106d34:	0f 84 c2 00 00 00    	je     80106dfc <switchuvm+0xec>
  pushcli();
80106d3a:	e8 01 da ff ff       	call   80104740 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106d3f:	e8 9c ce ff ff       	call   80103be0 <mycpu>
80106d44:	89 c3                	mov    %eax,%ebx
80106d46:	e8 95 ce ff ff       	call   80103be0 <mycpu>
80106d4b:	89 c7                	mov    %eax,%edi
80106d4d:	e8 8e ce ff ff       	call   80103be0 <mycpu>
80106d52:	83 c7 08             	add    $0x8,%edi
80106d55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106d58:	e8 83 ce ff ff       	call   80103be0 <mycpu>
80106d5d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106d60:	ba 67 00 00 00       	mov    $0x67,%edx
80106d65:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106d6c:	83 c0 08             	add    $0x8,%eax
80106d6f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106d76:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106d7b:	83 c1 08             	add    $0x8,%ecx
80106d7e:	c1 e8 18             	shr    $0x18,%eax
80106d81:	c1 e9 10             	shr    $0x10,%ecx
80106d84:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106d8a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106d90:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106d95:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106d9c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106da1:	e8 3a ce ff ff       	call   80103be0 <mycpu>
80106da6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106dad:	e8 2e ce ff ff       	call   80103be0 <mycpu>
80106db2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106db6:	8b 5e 08             	mov    0x8(%esi),%ebx
80106db9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106dbf:	e8 1c ce ff ff       	call   80103be0 <mycpu>
80106dc4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106dc7:	e8 14 ce ff ff       	call   80103be0 <mycpu>
80106dcc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106dd0:	b8 28 00 00 00       	mov    $0x28,%eax
80106dd5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106dd8:	8b 46 04             	mov    0x4(%esi),%eax
80106ddb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106de0:	0f 22 d8             	mov    %eax,%cr3
}
80106de3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106de6:	5b                   	pop    %ebx
80106de7:	5e                   	pop    %esi
80106de8:	5f                   	pop    %edi
80106de9:	5d                   	pop    %ebp
  popcli();
80106dea:	e9 a1 d9 ff ff       	jmp    80104790 <popcli>
    panic("switchuvm: no process");
80106def:	83 ec 0c             	sub    $0xc,%esp
80106df2:	68 e6 7f 10 80       	push   $0x80107fe6
80106df7:	e8 84 95 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106dfc:	83 ec 0c             	sub    $0xc,%esp
80106dff:	68 11 80 10 80       	push   $0x80108011
80106e04:	e8 77 95 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106e09:	83 ec 0c             	sub    $0xc,%esp
80106e0c:	68 fc 7f 10 80       	push   $0x80107ffc
80106e11:	e8 6a 95 ff ff       	call   80100380 <panic>
80106e16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e1d:	8d 76 00             	lea    0x0(%esi),%esi

80106e20 <inituvm>:
{
80106e20:	55                   	push   %ebp
80106e21:	89 e5                	mov    %esp,%ebp
80106e23:	57                   	push   %edi
80106e24:	56                   	push   %esi
80106e25:	53                   	push   %ebx
80106e26:	83 ec 1c             	sub    $0x1c,%esp
80106e29:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e2c:	8b 75 10             	mov    0x10(%ebp),%esi
80106e2f:	8b 7d 08             	mov    0x8(%ebp),%edi
80106e32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106e35:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106e3b:	77 4b                	ja     80106e88 <inituvm+0x68>
  mem = kalloc();
80106e3d:	e8 de b8 ff ff       	call   80102720 <kalloc>
  memset(mem, 0, PGSIZE);
80106e42:	83 ec 04             	sub    $0x4,%esp
80106e45:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106e4a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106e4c:	6a 00                	push   $0x0
80106e4e:	50                   	push   %eax
80106e4f:	e8 fc da ff ff       	call   80104950 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106e54:	58                   	pop    %eax
80106e55:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106e5b:	5a                   	pop    %edx
80106e5c:	6a 06                	push   $0x6
80106e5e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e63:	31 d2                	xor    %edx,%edx
80106e65:	50                   	push   %eax
80106e66:	89 f8                	mov    %edi,%eax
80106e68:	e8 13 fd ff ff       	call   80106b80 <mappages>
  memmove(mem, init, sz);
80106e6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e70:	89 75 10             	mov    %esi,0x10(%ebp)
80106e73:	83 c4 10             	add    $0x10,%esp
80106e76:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106e79:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80106e7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e7f:	5b                   	pop    %ebx
80106e80:	5e                   	pop    %esi
80106e81:	5f                   	pop    %edi
80106e82:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106e83:	e9 68 db ff ff       	jmp    801049f0 <memmove>
    panic("inituvm: more than a page");
80106e88:	83 ec 0c             	sub    $0xc,%esp
80106e8b:	68 25 80 10 80       	push   $0x80108025
80106e90:	e8 eb 94 ff ff       	call   80100380 <panic>
80106e95:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106ea0 <loaduvm>:
{
80106ea0:	55                   	push   %ebp
80106ea1:	89 e5                	mov    %esp,%ebp
80106ea3:	57                   	push   %edi
80106ea4:	56                   	push   %esi
80106ea5:	53                   	push   %ebx
80106ea6:	83 ec 1c             	sub    $0x1c,%esp
80106ea9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106eac:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106eaf:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106eb4:	0f 85 bb 00 00 00    	jne    80106f75 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
80106eba:	01 f0                	add    %esi,%eax
80106ebc:	89 f3                	mov    %esi,%ebx
80106ebe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ec1:	8b 45 14             	mov    0x14(%ebp),%eax
80106ec4:	01 f0                	add    %esi,%eax
80106ec6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106ec9:	85 f6                	test   %esi,%esi
80106ecb:	0f 84 87 00 00 00    	je     80106f58 <loaduvm+0xb8>
80106ed1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80106ed8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
80106edb:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106ede:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80106ee0:	89 c2                	mov    %eax,%edx
80106ee2:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106ee5:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80106ee8:	f6 c2 01             	test   $0x1,%dl
80106eeb:	75 13                	jne    80106f00 <loaduvm+0x60>
      panic("loaduvm: address should exist");
80106eed:	83 ec 0c             	sub    $0xc,%esp
80106ef0:	68 3f 80 10 80       	push   $0x8010803f
80106ef5:	e8 86 94 ff ff       	call   80100380 <panic>
80106efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106f00:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106f03:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80106f09:	25 fc 0f 00 00       	and    $0xffc,%eax
80106f0e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106f15:	85 c0                	test   %eax,%eax
80106f17:	74 d4                	je     80106eed <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80106f19:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f1b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106f1e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106f23:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106f28:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106f2e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f31:	29 d9                	sub    %ebx,%ecx
80106f33:	05 00 00 00 80       	add    $0x80000000,%eax
80106f38:	57                   	push   %edi
80106f39:	51                   	push   %ecx
80106f3a:	50                   	push   %eax
80106f3b:	ff 75 10             	push   0x10(%ebp)
80106f3e:	e8 4d ab ff ff       	call   80101a90 <readi>
80106f43:	83 c4 10             	add    $0x10,%esp
80106f46:	39 f8                	cmp    %edi,%eax
80106f48:	75 1e                	jne    80106f68 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80106f4a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106f50:	89 f0                	mov    %esi,%eax
80106f52:	29 d8                	sub    %ebx,%eax
80106f54:	39 c6                	cmp    %eax,%esi
80106f56:	77 80                	ja     80106ed8 <loaduvm+0x38>
}
80106f58:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106f5b:	31 c0                	xor    %eax,%eax
}
80106f5d:	5b                   	pop    %ebx
80106f5e:	5e                   	pop    %esi
80106f5f:	5f                   	pop    %edi
80106f60:	5d                   	pop    %ebp
80106f61:	c3                   	ret    
80106f62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f68:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106f6b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f70:	5b                   	pop    %ebx
80106f71:	5e                   	pop    %esi
80106f72:	5f                   	pop    %edi
80106f73:	5d                   	pop    %ebp
80106f74:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80106f75:	83 ec 0c             	sub    $0xc,%esp
80106f78:	68 0c 81 10 80       	push   $0x8010810c
80106f7d:	e8 fe 93 ff ff       	call   80100380 <panic>
80106f82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106f90 <allocuvm>:
{
80106f90:	55                   	push   %ebp
80106f91:	89 e5                	mov    %esp,%ebp
80106f93:	57                   	push   %edi
80106f94:	56                   	push   %esi
80106f95:	53                   	push   %ebx
80106f96:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106f99:	8b 45 10             	mov    0x10(%ebp),%eax
{
80106f9c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80106f9f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106fa2:	85 c0                	test   %eax,%eax
80106fa4:	0f 88 b6 00 00 00    	js     80107060 <allocuvm+0xd0>
  if(newsz < oldsz)
80106faa:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80106fad:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80106fb0:	0f 82 9a 00 00 00    	jb     80107050 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106fb6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106fbc:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106fc2:	39 75 10             	cmp    %esi,0x10(%ebp)
80106fc5:	77 44                	ja     8010700b <allocuvm+0x7b>
80106fc7:	e9 87 00 00 00       	jmp    80107053 <allocuvm+0xc3>
80106fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80106fd0:	83 ec 04             	sub    $0x4,%esp
80106fd3:	68 00 10 00 00       	push   $0x1000
80106fd8:	6a 00                	push   $0x0
80106fda:	50                   	push   %eax
80106fdb:	e8 70 d9 ff ff       	call   80104950 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106fe0:	58                   	pop    %eax
80106fe1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106fe7:	5a                   	pop    %edx
80106fe8:	6a 06                	push   $0x6
80106fea:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106fef:	89 f2                	mov    %esi,%edx
80106ff1:	50                   	push   %eax
80106ff2:	89 f8                	mov    %edi,%eax
80106ff4:	e8 87 fb ff ff       	call   80106b80 <mappages>
80106ff9:	83 c4 10             	add    $0x10,%esp
80106ffc:	85 c0                	test   %eax,%eax
80106ffe:	78 78                	js     80107078 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107000:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107006:	39 75 10             	cmp    %esi,0x10(%ebp)
80107009:	76 48                	jbe    80107053 <allocuvm+0xc3>
    mem = kalloc();
8010700b:	e8 10 b7 ff ff       	call   80102720 <kalloc>
80107010:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107012:	85 c0                	test   %eax,%eax
80107014:	75 ba                	jne    80106fd0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107016:	83 ec 0c             	sub    $0xc,%esp
80107019:	68 5d 80 10 80       	push   $0x8010805d
8010701e:	e8 7d 96 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107023:	8b 45 0c             	mov    0xc(%ebp),%eax
80107026:	83 c4 10             	add    $0x10,%esp
80107029:	39 45 10             	cmp    %eax,0x10(%ebp)
8010702c:	74 32                	je     80107060 <allocuvm+0xd0>
8010702e:	8b 55 10             	mov    0x10(%ebp),%edx
80107031:	89 c1                	mov    %eax,%ecx
80107033:	89 f8                	mov    %edi,%eax
80107035:	e8 76 fa ff ff       	call   80106ab0 <deallocuvm.part.0>
      return 0;
8010703a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107041:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107044:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107047:	5b                   	pop    %ebx
80107048:	5e                   	pop    %esi
80107049:	5f                   	pop    %edi
8010704a:	5d                   	pop    %ebp
8010704b:	c3                   	ret    
8010704c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107050:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107053:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107056:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107059:	5b                   	pop    %ebx
8010705a:	5e                   	pop    %esi
8010705b:	5f                   	pop    %edi
8010705c:	5d                   	pop    %ebp
8010705d:	c3                   	ret    
8010705e:	66 90                	xchg   %ax,%ax
    return 0;
80107060:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107067:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010706a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010706d:	5b                   	pop    %ebx
8010706e:	5e                   	pop    %esi
8010706f:	5f                   	pop    %edi
80107070:	5d                   	pop    %ebp
80107071:	c3                   	ret    
80107072:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107078:	83 ec 0c             	sub    $0xc,%esp
8010707b:	68 75 80 10 80       	push   $0x80108075
80107080:	e8 1b 96 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107085:	8b 45 0c             	mov    0xc(%ebp),%eax
80107088:	83 c4 10             	add    $0x10,%esp
8010708b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010708e:	74 0c                	je     8010709c <allocuvm+0x10c>
80107090:	8b 55 10             	mov    0x10(%ebp),%edx
80107093:	89 c1                	mov    %eax,%ecx
80107095:	89 f8                	mov    %edi,%eax
80107097:	e8 14 fa ff ff       	call   80106ab0 <deallocuvm.part.0>
      kfree(mem);
8010709c:	83 ec 0c             	sub    $0xc,%esp
8010709f:	53                   	push   %ebx
801070a0:	e8 1b b4 ff ff       	call   801024c0 <kfree>
      return 0;
801070a5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801070ac:	83 c4 10             	add    $0x10,%esp
}
801070af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801070b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070b5:	5b                   	pop    %ebx
801070b6:	5e                   	pop    %esi
801070b7:	5f                   	pop    %edi
801070b8:	5d                   	pop    %ebp
801070b9:	c3                   	ret    
801070ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801070c0 <deallocuvm>:
{
801070c0:	55                   	push   %ebp
801070c1:	89 e5                	mov    %esp,%ebp
801070c3:	8b 55 0c             	mov    0xc(%ebp),%edx
801070c6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801070c9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801070cc:	39 d1                	cmp    %edx,%ecx
801070ce:	73 10                	jae    801070e0 <deallocuvm+0x20>
}
801070d0:	5d                   	pop    %ebp
801070d1:	e9 da f9 ff ff       	jmp    80106ab0 <deallocuvm.part.0>
801070d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070dd:	8d 76 00             	lea    0x0(%esi),%esi
801070e0:	89 d0                	mov    %edx,%eax
801070e2:	5d                   	pop    %ebp
801070e3:	c3                   	ret    
801070e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801070ef:	90                   	nop

801070f0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801070f0:	55                   	push   %ebp
801070f1:	89 e5                	mov    %esp,%ebp
801070f3:	57                   	push   %edi
801070f4:	56                   	push   %esi
801070f5:	53                   	push   %ebx
801070f6:	83 ec 0c             	sub    $0xc,%esp
801070f9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801070fc:	85 f6                	test   %esi,%esi
801070fe:	74 59                	je     80107159 <freevm+0x69>
  if(newsz >= oldsz)
80107100:	31 c9                	xor    %ecx,%ecx
80107102:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107107:	89 f0                	mov    %esi,%eax
80107109:	89 f3                	mov    %esi,%ebx
8010710b:	e8 a0 f9 ff ff       	call   80106ab0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107110:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107116:	eb 0f                	jmp    80107127 <freevm+0x37>
80107118:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010711f:	90                   	nop
80107120:	83 c3 04             	add    $0x4,%ebx
80107123:	39 df                	cmp    %ebx,%edi
80107125:	74 23                	je     8010714a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107127:	8b 03                	mov    (%ebx),%eax
80107129:	a8 01                	test   $0x1,%al
8010712b:	74 f3                	je     80107120 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010712d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107132:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107135:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107138:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010713d:	50                   	push   %eax
8010713e:	e8 7d b3 ff ff       	call   801024c0 <kfree>
80107143:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107146:	39 df                	cmp    %ebx,%edi
80107148:	75 dd                	jne    80107127 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010714a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010714d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107150:	5b                   	pop    %ebx
80107151:	5e                   	pop    %esi
80107152:	5f                   	pop    %edi
80107153:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107154:	e9 67 b3 ff ff       	jmp    801024c0 <kfree>
    panic("freevm: no pgdir");
80107159:	83 ec 0c             	sub    $0xc,%esp
8010715c:	68 91 80 10 80       	push   $0x80108091
80107161:	e8 1a 92 ff ff       	call   80100380 <panic>
80107166:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010716d:	8d 76 00             	lea    0x0(%esi),%esi

80107170 <setupkvm>:
{
80107170:	55                   	push   %ebp
80107171:	89 e5                	mov    %esp,%ebp
80107173:	56                   	push   %esi
80107174:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107175:	e8 a6 b5 ff ff       	call   80102720 <kalloc>
8010717a:	89 c6                	mov    %eax,%esi
8010717c:	85 c0                	test   %eax,%eax
8010717e:	74 42                	je     801071c2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107180:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107183:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107188:	68 00 10 00 00       	push   $0x1000
8010718d:	6a 00                	push   $0x0
8010718f:	50                   	push   %eax
80107190:	e8 bb d7 ff ff       	call   80104950 <memset>
80107195:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107198:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010719b:	83 ec 08             	sub    $0x8,%esp
8010719e:	8b 4b 08             	mov    0x8(%ebx),%ecx
801071a1:	ff 73 0c             	push   0xc(%ebx)
801071a4:	8b 13                	mov    (%ebx),%edx
801071a6:	50                   	push   %eax
801071a7:	29 c1                	sub    %eax,%ecx
801071a9:	89 f0                	mov    %esi,%eax
801071ab:	e8 d0 f9 ff ff       	call   80106b80 <mappages>
801071b0:	83 c4 10             	add    $0x10,%esp
801071b3:	85 c0                	test   %eax,%eax
801071b5:	78 19                	js     801071d0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801071b7:	83 c3 10             	add    $0x10,%ebx
801071ba:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801071c0:	75 d6                	jne    80107198 <setupkvm+0x28>
}
801071c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801071c5:	89 f0                	mov    %esi,%eax
801071c7:	5b                   	pop    %ebx
801071c8:	5e                   	pop    %esi
801071c9:	5d                   	pop    %ebp
801071ca:	c3                   	ret    
801071cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801071cf:	90                   	nop
      freevm(pgdir);
801071d0:	83 ec 0c             	sub    $0xc,%esp
801071d3:	56                   	push   %esi
      return 0;
801071d4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801071d6:	e8 15 ff ff ff       	call   801070f0 <freevm>
      return 0;
801071db:	83 c4 10             	add    $0x10,%esp
}
801071de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801071e1:	89 f0                	mov    %esi,%eax
801071e3:	5b                   	pop    %ebx
801071e4:	5e                   	pop    %esi
801071e5:	5d                   	pop    %ebp
801071e6:	c3                   	ret    
801071e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071ee:	66 90                	xchg   %ax,%ax

801071f0 <kvmalloc>:
{
801071f0:	55                   	push   %ebp
801071f1:	89 e5                	mov    %esp,%ebp
801071f3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801071f6:	e8 75 ff ff ff       	call   80107170 <setupkvm>
801071fb:	a3 c4 d4 14 80       	mov    %eax,0x8014d4c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107200:	05 00 00 00 80       	add    $0x80000000,%eax
80107205:	0f 22 d8             	mov    %eax,%cr3
}
80107208:	c9                   	leave  
80107209:	c3                   	ret    
8010720a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107210 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107210:	55                   	push   %ebp
80107211:	89 e5                	mov    %esp,%ebp
80107213:	83 ec 08             	sub    $0x8,%esp
80107216:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107219:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010721c:	89 c1                	mov    %eax,%ecx
8010721e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107221:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107224:	f6 c2 01             	test   $0x1,%dl
80107227:	75 17                	jne    80107240 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107229:	83 ec 0c             	sub    $0xc,%esp
8010722c:	68 a2 80 10 80       	push   $0x801080a2
80107231:	e8 4a 91 ff ff       	call   80100380 <panic>
80107236:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010723d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107240:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107243:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107249:	25 fc 0f 00 00       	and    $0xffc,%eax
8010724e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107255:	85 c0                	test   %eax,%eax
80107257:	74 d0                	je     80107229 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107259:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010725c:	c9                   	leave  
8010725d:	c3                   	ret    
8010725e:	66 90                	xchg   %ax,%ax

80107260 <copyuvm>:

// Given a parent process's page table,
// create a copy of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107260:	55                   	push   %ebp
80107261:	89 e5                	mov    %esp,%ebp
80107263:	57                   	push   %edi
80107264:	56                   	push   %esi
80107265:	53                   	push   %ebx
80107266:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;

  if((d = setupkvm()) == 0)
80107269:	e8 02 ff ff ff       	call   80107170 <setupkvm>
8010726e:	89 c6                	mov    %eax,%esi
80107270:	85 c0                	test   %eax,%eax
80107272:	0f 84 a8 00 00 00    	je     80107320 <copyuvm+0xc0>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107278:	8b 45 0c             	mov    0xc(%ebp),%eax
8010727b:	85 c0                	test   %eax,%eax
8010727d:	0f 84 9d 00 00 00    	je     80107320 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    *pte = *pte & ~PTE_W;
    lcr3(V2P(pgdir));
80107283:	8b 45 08             	mov    0x8(%ebp),%eax
  for(i = 0; i < sz; i += PGSIZE){
80107286:	31 ff                	xor    %edi,%edi
    lcr3(V2P(pgdir));
80107288:	05 00 00 00 80       	add    $0x80000000,%eax
8010728d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(*pde & PTE_P){
80107290:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107293:	89 f8                	mov    %edi,%eax
80107295:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107298:	8b 04 82             	mov    (%edx,%eax,4),%eax
8010729b:	a8 01                	test   $0x1,%al
8010729d:	75 11                	jne    801072b0 <copyuvm+0x50>
      panic("copyuvm: pte should exist");
8010729f:	83 ec 0c             	sub    $0xc,%esp
801072a2:	68 ac 80 10 80       	push   $0x801080ac
801072a7:	e8 d4 90 ff ff       	call   80100380 <panic>
801072ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
801072b0:	89 f9                	mov    %edi,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801072b2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801072b7:	c1 e9 0a             	shr    $0xa,%ecx
801072ba:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
801072c0:	8d 8c 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%ecx
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801072c7:	85 c9                	test   %ecx,%ecx
801072c9:	74 d4                	je     8010729f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
801072cb:	8b 01                	mov    (%ecx),%eax
801072cd:	a8 01                	test   $0x1,%al
801072cf:	74 7d                	je     8010734e <copyuvm+0xee>
    *pte = *pte & ~PTE_W;
801072d1:	89 c3                	mov    %eax,%ebx
801072d3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801072d6:	83 e3 fd             	and    $0xfffffffd,%ebx
801072d9:	89 19                	mov    %ebx,(%ecx)
801072db:	0f 22 da             	mov    %edx,%cr3
    pa = PTE_ADDR(*pte);
801072de:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
    if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0)
801072e0:	83 ec 08             	sub    $0x8,%esp
    flags = PTE_FLAGS(*pte);
801072e3:	25 fd 0f 00 00       	and    $0xffd,%eax
    if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0)
801072e8:	b9 00 10 00 00       	mov    $0x1000,%ecx
    pa = PTE_ADDR(*pte);
801072ed:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0)
801072f3:	50                   	push   %eax
801072f4:	89 fa                	mov    %edi,%edx
801072f6:	89 f0                	mov    %esi,%eax
801072f8:	53                   	push   %ebx
801072f9:	e8 82 f8 ff ff       	call   80106b80 <mappages>
801072fe:	83 c4 10             	add    $0x10,%esp
80107301:	85 c0                	test   %eax,%eax
80107303:	78 2b                	js     80107330 <copyuvm+0xd0>
      goto bad;
    incr_refc(pa);
80107305:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < sz; i += PGSIZE){
80107308:	81 c7 00 10 00 00    	add    $0x1000,%edi
    incr_refc(pa);
8010730e:	53                   	push   %ebx
8010730f:	e8 9c b4 ff ff       	call   801027b0 <incr_refc>
  for(i = 0; i < sz; i += PGSIZE){
80107314:	83 c4 10             	add    $0x10,%esp
80107317:	39 7d 0c             	cmp    %edi,0xc(%ebp)
8010731a:	0f 87 70 ff ff ff    	ja     80107290 <copyuvm+0x30>

bad:
  freevm(d);
  lcr3(V2P(pgdir));
  return 0;
}
80107320:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107323:	89 f0                	mov    %esi,%eax
80107325:	5b                   	pop    %ebx
80107326:	5e                   	pop    %esi
80107327:	5f                   	pop    %edi
80107328:	5d                   	pop    %ebp
80107329:	c3                   	ret    
8010732a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  freevm(d);
80107330:	83 ec 0c             	sub    $0xc,%esp
80107333:	56                   	push   %esi
80107334:	e8 b7 fd ff ff       	call   801070f0 <freevm>
80107339:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010733c:	0f 22 d8             	mov    %eax,%cr3
  return 0;
8010733f:	31 f6                	xor    %esi,%esi
80107341:	83 c4 10             	add    $0x10,%esp
}
80107344:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107347:	5b                   	pop    %ebx
80107348:	89 f0                	mov    %esi,%eax
8010734a:	5e                   	pop    %esi
8010734b:	5f                   	pop    %edi
8010734c:	5d                   	pop    %ebp
8010734d:	c3                   	ret    
      panic("copyuvm: page not present");
8010734e:	83 ec 0c             	sub    $0xc,%esp
80107351:	68 c6 80 10 80       	push   $0x801080c6
80107356:	e8 25 90 ff ff       	call   80100380 <panic>
8010735b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010735f:	90                   	nop

80107360 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107360:	55                   	push   %ebp
80107361:	89 e5                	mov    %esp,%ebp
80107363:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107366:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107369:	89 c1                	mov    %eax,%ecx
8010736b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010736e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107371:	f6 c2 01             	test   $0x1,%dl
80107374:	0f 84 2f 03 00 00    	je     801076a9 <uva2ka.cold>
  return &pgtab[PTX(va)];
8010737a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010737d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107383:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107384:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107389:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107390:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107392:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107397:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010739a:	05 00 00 00 80       	add    $0x80000000,%eax
8010739f:	83 fa 05             	cmp    $0x5,%edx
801073a2:	ba 00 00 00 00       	mov    $0x0,%edx
801073a7:	0f 45 c2             	cmovne %edx,%eax
}
801073aa:	c3                   	ret    
801073ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801073af:	90                   	nop

801073b0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801073b0:	55                   	push   %ebp
801073b1:	89 e5                	mov    %esp,%ebp
801073b3:	57                   	push   %edi
801073b4:	56                   	push   %esi
801073b5:	53                   	push   %ebx
801073b6:	83 ec 0c             	sub    $0xc,%esp
801073b9:	8b 75 14             	mov    0x14(%ebp),%esi
801073bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801073bf:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801073c2:	85 f6                	test   %esi,%esi
801073c4:	75 51                	jne    80107417 <copyout+0x67>
801073c6:	e9 a5 00 00 00       	jmp    80107470 <copyout+0xc0>
801073cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801073cf:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
801073d0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801073d6:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
801073dc:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
801073e2:	74 75                	je     80107459 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
801073e4:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801073e6:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
801073e9:	29 c3                	sub    %eax,%ebx
801073eb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801073f1:	39 f3                	cmp    %esi,%ebx
801073f3:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
801073f6:	29 f8                	sub    %edi,%eax
801073f8:	83 ec 04             	sub    $0x4,%esp
801073fb:	01 c1                	add    %eax,%ecx
801073fd:	53                   	push   %ebx
801073fe:	52                   	push   %edx
801073ff:	51                   	push   %ecx
80107400:	e8 eb d5 ff ff       	call   801049f0 <memmove>
    len -= n;
    buf += n;
80107405:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107408:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010740e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107411:	01 da                	add    %ebx,%edx
  while(len > 0){
80107413:	29 de                	sub    %ebx,%esi
80107415:	74 59                	je     80107470 <copyout+0xc0>
  if(*pde & PTE_P){
80107417:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010741a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010741c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010741e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107421:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107427:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010742a:	f6 c1 01             	test   $0x1,%cl
8010742d:	0f 84 7d 02 00 00    	je     801076b0 <copyout.cold>
  return &pgtab[PTX(va)];
80107433:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107435:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010743b:	c1 eb 0c             	shr    $0xc,%ebx
8010743e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107444:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010744b:	89 d9                	mov    %ebx,%ecx
8010744d:	83 e1 05             	and    $0x5,%ecx
80107450:	83 f9 05             	cmp    $0x5,%ecx
80107453:	0f 84 77 ff ff ff    	je     801073d0 <copyout+0x20>
  }
  return 0;
}
80107459:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010745c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107461:	5b                   	pop    %ebx
80107462:	5e                   	pop    %esi
80107463:	5f                   	pop    %edi
80107464:	5d                   	pop    %ebp
80107465:	c3                   	ret    
80107466:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010746d:	8d 76 00             	lea    0x0(%esi),%esi
80107470:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107473:	31 c0                	xor    %eax,%eax
}
80107475:	5b                   	pop    %ebx
80107476:	5e                   	pop    %esi
80107477:	5f                   	pop    %edi
80107478:	5d                   	pop    %ebp
80107479:	c3                   	ret    
8010747a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107480 <CoW_handler>:

void
CoW_handler(void)
{
80107480:	55                   	push   %ebp
80107481:	89 e5                	mov    %esp,%ebp
80107483:	57                   	push   %edi
80107484:	56                   	push   %esi
80107485:	53                   	push   %ebx
80107486:	83 ec 1c             	sub    $0x1c,%esp
  pte_t *pte;
  uint pa, addr, flags;
  char *mem;
  int refc;
  struct proc *curproc = myproc();
80107489:	e8 d2 c7 ff ff       	call   80103c60 <myproc>
8010748e:	89 c3                	mov    %eax,%ebx
  asm volatile("movl %%cr2,%0" : "=r" (val));
80107490:	0f 20 d0             	mov    %cr2,%eax
  
  addr = PGROUNDDOWN(rcr2());

  if(addr < 0 || addr >= KERNBASE){
80107493:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107498:	0f 88 c2 00 00 00    	js     80107560 <CoW_handler+0xe0>
  if(*pde & PTE_P){
8010749e:	8b 53 04             	mov    0x4(%ebx),%edx
  pde = &pgdir[PDX(va)];
801074a1:	89 c1                	mov    %eax,%ecx
801074a3:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801074a6:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801074a9:	f6 c2 01             	test   $0x1,%dl
801074ac:	0f 84 e6 00 00 00    	je     80107598 <CoW_handler+0x118>
  return &pgtab[PTX(va)];
801074b2:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801074b5:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801074bb:	25 fc 0f 00 00       	and    $0xffc,%eax
801074c0:	8d bc 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%edi
    cprintf("CoW_handler: wrong virtual address\n");
    goto bad;
  }
  if((pte = walkpgdir(curproc->pgdir, (void *)addr, 0)) == 0){
801074c7:	85 ff                	test   %edi,%edi
801074c9:	0f 84 c9 00 00 00    	je     80107598 <CoW_handler+0x118>
    cprintf("CoW_handler: pte should exist\n");
    goto bad;
  }
  if(!(*pte & PTE_P)){
801074cf:	8b 37                	mov    (%edi),%esi
801074d1:	f7 c6 01 00 00 00    	test   $0x1,%esi
801074d7:	0f 84 a3 00 00 00    	je     80107580 <CoW_handler+0x100>
    cprintf("CoW_handler: pte not present\n");
    goto bad;
  }
  pa = PTE_ADDR(*pte);
801074dd:	89 f0                	mov    %esi,%eax
  flags = PTE_FLAGS(*pte);
  refc = get_refc(pa);
801074df:	83 ec 0c             	sub    $0xc,%esp
  pa = PTE_ADDR(*pte);
801074e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  refc = get_refc(pa);
801074e7:	50                   	push   %eax
  pa = PTE_ADDR(*pte);
801074e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  refc = get_refc(pa);
801074eb:	e8 00 b4 ff ff       	call   801028f0 <get_refc>

  // If there is no process referencing this page,
  // change the permission to writable.
  if (refc == 1)
801074f0:	83 c4 10             	add    $0x10,%esp
801074f3:	83 f8 01             	cmp    $0x1,%eax
801074f6:	0f 84 b4 00 00 00    	je     801075b0 <CoW_handler+0x130>
    *pte = *pte | PTE_W;
  else if (refc > 1){           // Start copying the page.
801074fc:	0f 8e b3 00 00 00    	jle    801075b5 <CoW_handler+0x135>
    if((mem = kalloc()) == 0)
80107502:	e8 19 b2 ff ff       	call   80102720 <kalloc>
80107507:	89 c2                	mov    %eax,%edx
80107509:	85 c0                	test   %eax,%eax
8010750b:	74 63                	je     80107570 <CoW_handler+0xf0>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
8010750d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107510:	83 ec 04             	sub    $0x4,%esp
80107513:	89 55 e0             	mov    %edx,-0x20(%ebp)
  flags = PTE_FLAGS(*pte);
80107516:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
    memmove(mem, (char*)P2V(pa), PGSIZE);
8010751c:	68 00 10 00 00       	push   $0x1000
80107521:	05 00 00 00 80       	add    $0x80000000,%eax
80107526:	50                   	push   %eax
80107527:	52                   	push   %edx
80107528:	e8 c3 d4 ff ff       	call   801049f0 <memmove>
    *pte = V2P(mem) | flags | PTE_W;
8010752d:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107530:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107536:	09 f2                	or     %esi,%edx
80107538:	83 ca 02             	or     $0x2,%edx
8010753b:	89 17                	mov    %edx,(%edi)
    decr_refc(pa);
8010753d:	58                   	pop    %eax
8010753e:	ff 75 e4             	push   -0x1c(%ebp)
80107541:	e8 0a b3 ff ff       	call   80102850 <decr_refc>
80107546:	83 c4 10             	add    $0x10,%esp
  }
  else
    panic("CoW_handler");

  lcr3(V2P(curproc->pgdir));
80107549:	8b 43 04             	mov    0x4(%ebx),%eax
8010754c:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107551:	0f 22 d8             	mov    %eax,%cr3
  return;

  bad:
    curproc->killed = 1;
}
80107554:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107557:	5b                   	pop    %ebx
80107558:	5e                   	pop    %esi
80107559:	5f                   	pop    %edi
8010755a:	5d                   	pop    %ebp
8010755b:	c3                   	ret    
8010755c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("CoW_handler: wrong virtual address\n");
80107560:	83 ec 0c             	sub    $0xc,%esp
80107563:	68 30 81 10 80       	push   $0x80108130
80107568:	e8 33 91 ff ff       	call   801006a0 <cprintf>
    goto bad;
8010756d:	83 c4 10             	add    $0x10,%esp
    curproc->killed = 1;
80107570:	c7 43 24 01 00 00 00 	movl   $0x1,0x24(%ebx)
}
80107577:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010757a:	5b                   	pop    %ebx
8010757b:	5e                   	pop    %esi
8010757c:	5f                   	pop    %edi
8010757d:	5d                   	pop    %ebp
8010757e:	c3                   	ret    
8010757f:	90                   	nop
    cprintf("CoW_handler: pte not present\n");
80107580:	83 ec 0c             	sub    $0xc,%esp
80107583:	68 e0 80 10 80       	push   $0x801080e0
80107588:	e8 13 91 ff ff       	call   801006a0 <cprintf>
    goto bad;
8010758d:	83 c4 10             	add    $0x10,%esp
80107590:	eb de                	jmp    80107570 <CoW_handler+0xf0>
80107592:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("CoW_handler: pte should exist\n");
80107598:	83 ec 0c             	sub    $0xc,%esp
8010759b:	68 54 81 10 80       	push   $0x80108154
801075a0:	e8 fb 90 ff ff       	call   801006a0 <cprintf>
    goto bad;
801075a5:	83 c4 10             	add    $0x10,%esp
801075a8:	eb c6                	jmp    80107570 <CoW_handler+0xf0>
801075aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *pte = *pte | PTE_W;
801075b0:	83 0f 02             	orl    $0x2,(%edi)
801075b3:	eb 94                	jmp    80107549 <CoW_handler+0xc9>
    panic("CoW_handler");
801075b5:	83 ec 0c             	sub    $0xc,%esp
801075b8:	68 fe 80 10 80       	push   $0x801080fe
801075bd:	e8 be 8d ff ff       	call   80100380 <panic>
801075c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801075d0 <sys_countvp>:

int 
sys_countvp(void)
{
801075d0:	55                   	push   %ebp
801075d1:	89 e5                	mov    %esp,%ebp
801075d3:	83 ec 08             	sub    $0x8,%esp
  return PGROUNDUP(myproc()->sz) / PGSIZE;
801075d6:	e8 85 c6 ff ff       	call   80103c60 <myproc>
801075db:	8b 00                	mov    (%eax),%eax
}
801075dd:	c9                   	leave  
  return PGROUNDUP(myproc()->sz) / PGSIZE;
801075de:	05 ff 0f 00 00       	add    $0xfff,%eax
801075e3:	c1 e8 0c             	shr    $0xc,%eax
}
801075e6:	c3                   	ret    
801075e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075ee:	66 90                	xchg   %ax,%ax

801075f0 <sys_countpp>:

int
sys_countpp(void)
{
801075f0:	55                   	push   %ebp
801075f1:	89 e5                	mov    %esp,%ebp
801075f3:	57                   	push   %edi
801075f4:	56                   	push   %esi
801075f5:	53                   	push   %ebx
801075f6:	83 ec 0c             	sub    $0xc,%esp
  int ppc;
  uint i, sz;
  pde_t *pgdir;
  pte_t *pte;
  struct proc *curproc = myproc();
801075f9:	e8 62 c6 ff ff       	call   80103c60 <myproc>

  sz = curproc->sz;
801075fe:	8b 18                	mov    (%eax),%ebx
  pgdir = curproc->pgdir;
80107600:	8b 70 04             	mov    0x4(%eax),%esi
  ppc = 0;

  for (i = 0; i < sz; i += PGSIZE){
80107603:	85 db                	test   %ebx,%ebx
80107605:	74 59                	je     80107660 <sys_countpp+0x70>
80107607:	31 c0                	xor    %eax,%eax
  ppc = 0;
80107609:	31 c9                	xor    %ecx,%ecx
8010760b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010760f:	90                   	nop
  pde = &pgdir[PDX(va)];
80107610:	89 c2                	mov    %eax,%edx
80107612:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107615:	8b 14 96             	mov    (%esi,%edx,4),%edx
80107618:	f6 c2 01             	test   $0x1,%dl
8010761b:	74 27                	je     80107644 <sys_countpp+0x54>
  return &pgtab[PTX(va)];
8010761d:	89 c7                	mov    %eax,%edi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010761f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107625:	c1 ef 0a             	shr    $0xa,%edi
80107628:	81 e7 fc 0f 00 00    	and    $0xffc,%edi
8010762e:	8d 94 3a 00 00 00 80 	lea    -0x80000000(%edx,%edi,1),%edx
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107635:	85 d2                	test   %edx,%edx
80107637:	74 0b                	je     80107644 <sys_countpp+0x54>
      continue;
    if(!(*pte & PTE_P))
80107639:	8b 12                	mov    (%edx),%edx
8010763b:	83 e2 01             	and    $0x1,%edx
      continue;
    ppc ++;
8010763e:	83 fa 01             	cmp    $0x1,%edx
80107641:	83 d9 ff             	sbb    $0xffffffff,%ecx
  for (i = 0; i < sz; i += PGSIZE){
80107644:	05 00 10 00 00       	add    $0x1000,%eax
80107649:	39 c3                	cmp    %eax,%ebx
8010764b:	77 c3                	ja     80107610 <sys_countpp+0x20>
  }
  return ppc;
}
8010764d:	83 c4 0c             	add    $0xc,%esp
80107650:	89 c8                	mov    %ecx,%eax
80107652:	5b                   	pop    %ebx
80107653:	5e                   	pop    %esi
80107654:	5f                   	pop    %edi
80107655:	5d                   	pop    %ebp
80107656:	c3                   	ret    
80107657:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010765e:	66 90                	xchg   %ax,%ax
80107660:	83 c4 0c             	add    $0xc,%esp
  ppc = 0;
80107663:	31 c9                	xor    %ecx,%ecx
}
80107665:	5b                   	pop    %ebx
80107666:	89 c8                	mov    %ecx,%eax
80107668:	5e                   	pop    %esi
80107669:	5f                   	pop    %edi
8010766a:	5d                   	pop    %ebp
8010766b:	c3                   	ret    
8010766c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107670 <sys_countptp>:

int
sys_countptp(void)
{
80107670:	55                   	push   %ebp
80107671:	89 e5                	mov    %esp,%ebp
80107673:	53                   	push   %ebx
80107674:	83 ec 04             	sub    $0x4,%esp
  pde_t *pgdir;
  uint i;
  int ptpc;
  struct proc *curproc = myproc();
80107677:	e8 e4 c5 ff ff       	call   80103c60 <myproc>

  pgdir = curproc->pgdir;
  ptpc = 1; // pgdir
8010767c:	b9 01 00 00 00       	mov    $0x1,%ecx
80107681:	8b 40 04             	mov    0x4(%eax),%eax
80107684:	8d 98 00 10 00 00    	lea    0x1000(%eax),%ebx
8010768a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  for(i = 0; i < NPDENTRIES; i++){
    if(pgdir[i] & PTE_P)
80107690:	8b 10                	mov    (%eax),%edx
80107692:	83 e2 01             	and    $0x1,%edx
      ptpc++;
80107695:	83 fa 01             	cmp    $0x1,%edx
80107698:	83 d9 ff             	sbb    $0xffffffff,%ecx
  for(i = 0; i < NPDENTRIES; i++){
8010769b:	83 c0 04             	add    $0x4,%eax
8010769e:	39 d8                	cmp    %ebx,%eax
801076a0:	75 ee                	jne    80107690 <sys_countptp+0x20>
  }

  return ptpc;
}
801076a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801076a5:	89 c8                	mov    %ecx,%eax
801076a7:	c9                   	leave  
801076a8:	c3                   	ret    

801076a9 <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801076a9:	a1 00 00 00 00       	mov    0x0,%eax
801076ae:	0f 0b                	ud2    

801076b0 <copyout.cold>:
801076b0:	a1 00 00 00 00       	mov    0x0,%eax
801076b5:	0f 0b                	ud2    
