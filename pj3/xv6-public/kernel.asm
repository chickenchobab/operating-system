
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
80100028:	bc d0 68 11 80       	mov    $0x801168d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 80 30 10 80       	mov    $0x80103080,%eax
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
8010004c:	68 a0 78 10 80       	push   $0x801078a0
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 75 48 00 00       	call   801048d0 <initlock>
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
80100092:	68 a7 78 10 80       	push   $0x801078a7
80100097:	50                   	push   %eax
80100098:	e8 03 47 00 00       	call   801047a0 <initsleeplock>
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
801000e4:	e8 b7 49 00 00       	call   80104aa0 <acquire>
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
80100162:	e8 d9 48 00 00       	call   80104a40 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 6e 46 00 00       	call   801047e0 <acquiresleep>
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
8010018c:	e8 6f 21 00 00       	call   80102300 <iderw>
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
801001a1:	68 ae 78 10 80       	push   $0x801078ae
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
801001be:	e8 bd 46 00 00       	call   80104880 <holdingsleep>
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
801001d4:	e9 27 21 00 00       	jmp    80102300 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 bf 78 10 80       	push   $0x801078bf
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
801001ff:	e8 7c 46 00 00       	call   80104880 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 2c 46 00 00       	call   80104840 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 80 48 00 00       	call   80104aa0 <acquire>
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
8010026c:	e9 cf 47 00 00       	jmp    80104a40 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 c6 78 10 80       	push   $0x801078c6
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
80100294:	e8 e7 15 00 00       	call   80101880 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801002a0:	e8 fb 47 00 00       	call   80104aa0 <acquire>
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
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ff 10 80       	push   $0x8010ff20
801002c8:	68 00 ff 10 80       	push   $0x8010ff00
801002cd:	e8 2e 3e 00 00       	call   80104100 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 29 37 00 00       	call   80103a10 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 45 47 00 00       	call   80104a40 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 9c 14 00 00       	call   801017a0 <ilock>
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
8010034c:	e8 ef 46 00 00       	call   80104a40 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 46 14 00 00       	call   801017a0 <ilock>
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
80100399:	e8 72 25 00 00       	call   80102910 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 cd 78 10 80       	push   $0x801078cd
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 03 82 10 80 	movl   $0x80108203,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 23 45 00 00       	call   801048f0 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 e1 78 10 80       	push   $0x801078e1
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
8010041a:	e8 91 5f 00 00       	call   801063b0 <uartputc>
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
80100505:	e8 a6 5e 00 00       	call   801063b0 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 9a 5e 00 00       	call   801063b0 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 8e 5e 00 00       	call   801063b0 <uartputc>
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
80100551:	e8 aa 46 00 00       	call   80104c00 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 f5 45 00 00       	call   80104b60 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 e5 78 10 80       	push   $0x801078e5
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
8010059f:	e8 dc 12 00 00       	call   80101880 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801005ab:	e8 f0 44 00 00       	call   80104aa0 <acquire>
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
801005e4:	e8 57 44 00 00       	call   80104a40 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 ae 11 00 00       	call   801017a0 <ilock>

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
80100636:	0f b6 92 10 79 10 80 	movzbl -0x7fef86f0(%edx),%edx
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
801007e8:	e8 b3 42 00 00       	call   80104aa0 <acquire>
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
80100838:	bf f8 78 10 80       	mov    $0x801078f8,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 ff 10 80       	push   $0x8010ff20
8010085b:	e8 e0 41 00 00       	call   80104a40 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 ff 78 10 80       	push   $0x801078ff
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
80100893:	e8 08 42 00 00       	call   80104aa0 <acquire>
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
801009d0:	e8 6b 40 00 00       	call   80104a40 <release>
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
80100a0e:	e9 8d 38 00 00       	jmp    801042a0 <procdump>
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
80100a44:	e8 77 37 00 00       	call   801041c0 <wakeup>
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
80100a66:	68 08 79 10 80       	push   $0x80107908
80100a6b:	68 20 ff 10 80       	push   $0x8010ff20
80100a70:	e8 5b 3e 00 00       	call   801048d0 <initlock>

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
80100a99:	e8 02 1a 00 00       	call   801024a0 <ioapicenable>
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
80100abc:	e8 4f 2f 00 00       	call   80103a10 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 b4 22 00 00       	call   80102d80 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 e9 15 00 00       	call   801020c0 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 04 03 00 00    	je     80100de6 <exec+0x336>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c3                	mov    %eax,%ebx
80100ae7:	50                   	push   %eax
80100ae8:	e8 b3 0c 00 00       	call   801017a0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	53                   	push   %ebx
80100af9:	e8 b2 0f 00 00       	call   80101ab0 <readi>
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
80100b0a:	e8 21 0f 00 00       	call   80101a30 <iunlockput>
    end_op();
80100b0f:	e8 dc 22 00 00       	call   80102df0 <end_op>
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
80100b34:	e8 07 6a 00 00       	call   80107540 <setupkvm>
80100b39:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b3f:	85 c0                	test   %eax,%eax
80100b41:	74 c3                	je     80100b06 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b43:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b4a:	00 
80100b4b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b51:	0f 84 ae 02 00 00    	je     80100e05 <exec+0x355>
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
80100ba3:	e8 b8 67 00 00       	call   80107360 <allocuvm>
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
80100bd9:	e8 92 66 00 00       	call   80107270 <loaduvm>
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
80100c01:	e8 aa 0e 00 00       	call   80101ab0 <readi>
80100c06:	83 c4 10             	add    $0x10,%esp
80100c09:	83 f8 20             	cmp    $0x20,%eax
80100c0c:	0f 84 5e ff ff ff    	je     80100b70 <exec+0xc0>
    freevm(pgdir);
80100c12:	83 ec 0c             	sub    $0xc,%esp
80100c15:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c1b:	e8 a0 68 00 00       	call   801074c0 <freevm>
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
80100c4c:	e8 df 0d 00 00       	call   80101a30 <iunlockput>
  end_op();
80100c51:	e8 9a 21 00 00       	call   80102df0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	56                   	push   %esi
80100c5a:	57                   	push   %edi
80100c5b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c61:	57                   	push   %edi
80100c62:	e8 f9 66 00 00       	call   80107360 <allocuvm>
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
80100c83:	e8 58 69 00 00       	call   801075e0 <clearpteu>
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
80100cd3:	e8 88 40 00 00       	call   80104d60 <strlen>
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
80100ce7:	e8 74 40 00 00       	call   80104d60 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 b3 6a 00 00       	call   801077b0 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 aa 67 00 00       	call   801074c0 <freevm>
80100d16:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d1e:	e9 f9 fd ff ff       	jmp    80100b1c <exec+0x6c>
80100d23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d29:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d30:	89 d9                	mov    %ebx,%ecx
  ustack[1] = argc;
80100d32:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[3+argc] = 0;
80100d38:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d3f:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d43:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d45:	89 df                	mov    %ebx,%edi
80100d47:	83 c0 0c             	add    $0xc,%eax
80100d4a:	29 c7                	sub    %eax,%edi
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d4c:	50                   	push   %eax
80100d4d:	52                   	push   %edx
80100d4e:	57                   	push   %edi
80100d4f:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d55:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d5c:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d5f:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d65:	e8 46 6a 00 00       	call   801077b0 <copyout>
80100d6a:	83 c4 10             	add    $0x10,%esp
80100d6d:	85 c0                	test   %eax,%eax
80100d6f:	78 97                	js     80100d08 <exec+0x258>
  for(last=s=path; *s; s++)
80100d71:	8b 45 08             	mov    0x8(%ebp),%eax
80100d74:	8b 55 08             	mov    0x8(%ebp),%edx
80100d77:	0f b6 00             	movzbl (%eax),%eax
80100d7a:	84 c0                	test   %al,%al
80100d7c:	74 11                	je     80100d8f <exec+0x2df>
80100d7e:	89 d1                	mov    %edx,%ecx
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
80100d8f:	8b 9d ec fe ff ff    	mov    -0x114(%ebp),%ebx
80100d95:	83 ec 04             	sub    $0x4,%esp
80100d98:	6a 10                	push   $0x10
80100d9a:	89 d8                	mov    %ebx,%eax
80100d9c:	52                   	push   %edx
80100d9d:	83 c0 6c             	add    $0x6c,%eax
80100da0:	50                   	push   %eax
80100da1:	e8 7a 3f 00 00       	call   80104d20 <safestrcpy>
  curproc->pgdir = pgdir;
80100da6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100dac:	89 d8                	mov    %ebx,%eax
80100dae:	8b 5b 04             	mov    0x4(%ebx),%ebx
  curproc->sz = sz;
80100db1:	89 30                	mov    %esi,(%eax)
  curproc->tf->eip = elf.entry;  // main
80100db3:	89 c6                	mov    %eax,%esi
  curproc->pgdir = pgdir;
80100db5:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100db8:	8b 40 18             	mov    0x18(%eax),%eax
80100dbb:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dc1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dc4:	8b 46 18             	mov    0x18(%esi),%eax
80100dc7:	89 78 44             	mov    %edi,0x44(%eax)
  switchuvm(curproc);
80100dca:	89 34 24             	mov    %esi,(%esp)
80100dcd:	e8 0e 63 00 00       	call   801070e0 <switchuvm>
  if (curproc->tid == 0)
80100dd2:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
80100dd8:	83 c4 10             	add    $0x10,%esp
80100ddb:	85 c0                	test   %eax,%eax
80100ddd:	74 32                	je     80100e11 <exec+0x361>
  return 0;
80100ddf:	31 c0                	xor    %eax,%eax
80100de1:	e9 36 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100de6:	e8 05 20 00 00       	call   80102df0 <end_op>
    cprintf("exec: fail\n");
80100deb:	83 ec 0c             	sub    $0xc,%esp
80100dee:	68 21 79 10 80       	push   $0x80107921
80100df3:	e8 a8 f8 ff ff       	call   801006a0 <cprintf>
    return -1;
80100df8:	83 c4 10             	add    $0x10,%esp
80100dfb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100e00:	e9 17 fd ff ff       	jmp    80100b1c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e05:	be 00 20 00 00       	mov    $0x2000,%esi
80100e0a:	31 ff                	xor    %edi,%edi
80100e0c:	e9 37 fe ff ff       	jmp    80100c48 <exec+0x198>
    freevm(oldpgdir);
80100e11:	83 ec 0c             	sub    $0xc,%esp
80100e14:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100e1a:	53                   	push   %ebx
80100e1b:	e8 a0 66 00 00       	call   801074c0 <freevm>
80100e20:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100e26:	83 c4 10             	add    $0x10,%esp
80100e29:	e9 ee fc ff ff       	jmp    80100b1c <exec+0x6c>
80100e2e:	66 90                	xchg   %ax,%ax

80100e30 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e36:	68 2d 79 10 80       	push   $0x8010792d
80100e3b:	68 60 ff 10 80       	push   $0x8010ff60
80100e40:	e8 8b 3a 00 00       	call   801048d0 <initlock>
}
80100e45:	83 c4 10             	add    $0x10,%esp
80100e48:	c9                   	leave  
80100e49:	c3                   	ret    
80100e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e50 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e50:	55                   	push   %ebp
80100e51:	89 e5                	mov    %esp,%ebp
80100e53:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e54:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
{
80100e59:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e5c:	68 60 ff 10 80       	push   $0x8010ff60
80100e61:	e8 3a 3c 00 00       	call   80104aa0 <acquire>
80100e66:	83 c4 10             	add    $0x10,%esp
80100e69:	eb 10                	jmp    80100e7b <filealloc+0x2b>
80100e6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e6f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e70:	83 c3 18             	add    $0x18,%ebx
80100e73:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
80100e79:	74 25                	je     80100ea0 <filealloc+0x50>
    if(f->ref == 0){
80100e7b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e7e:	85 c0                	test   %eax,%eax
80100e80:	75 ee                	jne    80100e70 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e82:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e85:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e8c:	68 60 ff 10 80       	push   $0x8010ff60
80100e91:	e8 aa 3b 00 00       	call   80104a40 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e96:	89 d8                	mov    %ebx,%eax
      return f;
80100e98:	83 c4 10             	add    $0x10,%esp
}
80100e9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e9e:	c9                   	leave  
80100e9f:	c3                   	ret    
  release(&ftable.lock);
80100ea0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100ea3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100ea5:	68 60 ff 10 80       	push   $0x8010ff60
80100eaa:	e8 91 3b 00 00       	call   80104a40 <release>
}
80100eaf:	89 d8                	mov    %ebx,%eax
  return 0;
80100eb1:	83 c4 10             	add    $0x10,%esp
}
80100eb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eb7:	c9                   	leave  
80100eb8:	c3                   	ret    
80100eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ec0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ec0:	55                   	push   %ebp
80100ec1:	89 e5                	mov    %esp,%ebp
80100ec3:	53                   	push   %ebx
80100ec4:	83 ec 10             	sub    $0x10,%esp
80100ec7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eca:	68 60 ff 10 80       	push   $0x8010ff60
80100ecf:	e8 cc 3b 00 00       	call   80104aa0 <acquire>
  if(f->ref < 1)
80100ed4:	8b 43 04             	mov    0x4(%ebx),%eax
80100ed7:	83 c4 10             	add    $0x10,%esp
80100eda:	85 c0                	test   %eax,%eax
80100edc:	7e 1a                	jle    80100ef8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ede:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ee1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ee4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ee7:	68 60 ff 10 80       	push   $0x8010ff60
80100eec:	e8 4f 3b 00 00       	call   80104a40 <release>
  return f;
}
80100ef1:	89 d8                	mov    %ebx,%eax
80100ef3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ef6:	c9                   	leave  
80100ef7:	c3                   	ret    
    panic("filedup");
80100ef8:	83 ec 0c             	sub    $0xc,%esp
80100efb:	68 34 79 10 80       	push   $0x80107934
80100f00:	e8 7b f4 ff ff       	call   80100380 <panic>
80100f05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f10 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	57                   	push   %edi
80100f14:	56                   	push   %esi
80100f15:	53                   	push   %ebx
80100f16:	83 ec 28             	sub    $0x28,%esp
80100f19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f1c:	68 60 ff 10 80       	push   $0x8010ff60
80100f21:	e8 7a 3b 00 00       	call   80104aa0 <acquire>
  if(f->ref < 1)
80100f26:	8b 53 04             	mov    0x4(%ebx),%edx
80100f29:	83 c4 10             	add    $0x10,%esp
80100f2c:	85 d2                	test   %edx,%edx
80100f2e:	0f 8e a5 00 00 00    	jle    80100fd9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f34:	83 ea 01             	sub    $0x1,%edx
80100f37:	89 53 04             	mov    %edx,0x4(%ebx)
80100f3a:	75 44                	jne    80100f80 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f3c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f40:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f43:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f45:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f4b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f4e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f51:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f54:	68 60 ff 10 80       	push   $0x8010ff60
  ff = *f;
80100f59:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f5c:	e8 df 3a 00 00       	call   80104a40 <release>

  if(ff.type == FD_PIPE)
80100f61:	83 c4 10             	add    $0x10,%esp
80100f64:	83 ff 01             	cmp    $0x1,%edi
80100f67:	74 57                	je     80100fc0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f69:	83 ff 02             	cmp    $0x2,%edi
80100f6c:	74 2a                	je     80100f98 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f71:	5b                   	pop    %ebx
80100f72:	5e                   	pop    %esi
80100f73:	5f                   	pop    %edi
80100f74:	5d                   	pop    %ebp
80100f75:	c3                   	ret    
80100f76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f7d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f80:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
}
80100f87:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8a:	5b                   	pop    %ebx
80100f8b:	5e                   	pop    %esi
80100f8c:	5f                   	pop    %edi
80100f8d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f8e:	e9 ad 3a 00 00       	jmp    80104a40 <release>
80100f93:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f97:	90                   	nop
    begin_op();
80100f98:	e8 e3 1d 00 00       	call   80102d80 <begin_op>
    iput(ff.ip);
80100f9d:	83 ec 0c             	sub    $0xc,%esp
80100fa0:	ff 75 e0             	push   -0x20(%ebp)
80100fa3:	e8 28 09 00 00       	call   801018d0 <iput>
    end_op();
80100fa8:	83 c4 10             	add    $0x10,%esp
}
80100fab:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fae:	5b                   	pop    %ebx
80100faf:	5e                   	pop    %esi
80100fb0:	5f                   	pop    %edi
80100fb1:	5d                   	pop    %ebp
    end_op();
80100fb2:	e9 39 1e 00 00       	jmp    80102df0 <end_op>
80100fb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fbe:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100fc0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fc4:	83 ec 08             	sub    $0x8,%esp
80100fc7:	53                   	push   %ebx
80100fc8:	56                   	push   %esi
80100fc9:	e8 82 25 00 00       	call   80103550 <pipeclose>
80100fce:	83 c4 10             	add    $0x10,%esp
}
80100fd1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fd4:	5b                   	pop    %ebx
80100fd5:	5e                   	pop    %esi
80100fd6:	5f                   	pop    %edi
80100fd7:	5d                   	pop    %ebp
80100fd8:	c3                   	ret    
    panic("fileclose");
80100fd9:	83 ec 0c             	sub    $0xc,%esp
80100fdc:	68 3c 79 10 80       	push   $0x8010793c
80100fe1:	e8 9a f3 ff ff       	call   80100380 <panic>
80100fe6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fed:	8d 76 00             	lea    0x0(%esi),%esi

80100ff0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	53                   	push   %ebx
80100ff4:	83 ec 04             	sub    $0x4,%esp
80100ff7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100ffa:	83 3b 02             	cmpl   $0x2,(%ebx)
80100ffd:	75 31                	jne    80101030 <filestat+0x40>
    ilock(f->ip);
80100fff:	83 ec 0c             	sub    $0xc,%esp
80101002:	ff 73 10             	push   0x10(%ebx)
80101005:	e8 96 07 00 00       	call   801017a0 <ilock>
    stati(f->ip, st);
8010100a:	58                   	pop    %eax
8010100b:	5a                   	pop    %edx
8010100c:	ff 75 0c             	push   0xc(%ebp)
8010100f:	ff 73 10             	push   0x10(%ebx)
80101012:	e8 69 0a 00 00       	call   80101a80 <stati>
    iunlock(f->ip);
80101017:	59                   	pop    %ecx
80101018:	ff 73 10             	push   0x10(%ebx)
8010101b:	e8 60 08 00 00       	call   80101880 <iunlock>
    return 0;
  }
  return -1;
}
80101020:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101023:	83 c4 10             	add    $0x10,%esp
80101026:	31 c0                	xor    %eax,%eax
}
80101028:	c9                   	leave  
80101029:	c3                   	ret    
8010102a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101030:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101033:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101038:	c9                   	leave  
80101039:	c3                   	ret    
8010103a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101040 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101040:	55                   	push   %ebp
80101041:	89 e5                	mov    %esp,%ebp
80101043:	57                   	push   %edi
80101044:	56                   	push   %esi
80101045:	53                   	push   %ebx
80101046:	83 ec 0c             	sub    $0xc,%esp
80101049:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010104c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010104f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101052:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101056:	74 60                	je     801010b8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101058:	8b 03                	mov    (%ebx),%eax
8010105a:	83 f8 01             	cmp    $0x1,%eax
8010105d:	74 41                	je     801010a0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010105f:	83 f8 02             	cmp    $0x2,%eax
80101062:	75 5b                	jne    801010bf <fileread+0x7f>
    ilock(f->ip);
80101064:	83 ec 0c             	sub    $0xc,%esp
80101067:	ff 73 10             	push   0x10(%ebx)
8010106a:	e8 31 07 00 00       	call   801017a0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010106f:	57                   	push   %edi
80101070:	ff 73 14             	push   0x14(%ebx)
80101073:	56                   	push   %esi
80101074:	ff 73 10             	push   0x10(%ebx)
80101077:	e8 34 0a 00 00       	call   80101ab0 <readi>
8010107c:	83 c4 20             	add    $0x20,%esp
8010107f:	89 c6                	mov    %eax,%esi
80101081:	85 c0                	test   %eax,%eax
80101083:	7e 03                	jle    80101088 <fileread+0x48>
      f->off += r;
80101085:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101088:	83 ec 0c             	sub    $0xc,%esp
8010108b:	ff 73 10             	push   0x10(%ebx)
8010108e:	e8 ed 07 00 00       	call   80101880 <iunlock>
    return r;
80101093:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101096:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101099:	89 f0                	mov    %esi,%eax
8010109b:	5b                   	pop    %ebx
8010109c:	5e                   	pop    %esi
8010109d:	5f                   	pop    %edi
8010109e:	5d                   	pop    %ebp
8010109f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
801010a0:	8b 43 0c             	mov    0xc(%ebx),%eax
801010a3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010a9:	5b                   	pop    %ebx
801010aa:	5e                   	pop    %esi
801010ab:	5f                   	pop    %edi
801010ac:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801010ad:	e9 3e 26 00 00       	jmp    801036f0 <piperead>
801010b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801010b8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801010bd:	eb d7                	jmp    80101096 <fileread+0x56>
  panic("fileread");
801010bf:	83 ec 0c             	sub    $0xc,%esp
801010c2:	68 46 79 10 80       	push   $0x80107946
801010c7:	e8 b4 f2 ff ff       	call   80100380 <panic>
801010cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010d0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010d0:	55                   	push   %ebp
801010d1:	89 e5                	mov    %esp,%ebp
801010d3:	57                   	push   %edi
801010d4:	56                   	push   %esi
801010d5:	53                   	push   %ebx
801010d6:	83 ec 1c             	sub    $0x1c,%esp
801010d9:	8b 45 0c             	mov    0xc(%ebp),%eax
801010dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010df:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010e2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010e5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801010e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010ec:	0f 84 bd 00 00 00    	je     801011af <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
801010f2:	8b 03                	mov    (%ebx),%eax
801010f4:	83 f8 01             	cmp    $0x1,%eax
801010f7:	0f 84 bf 00 00 00    	je     801011bc <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010fd:	83 f8 02             	cmp    $0x2,%eax
80101100:	0f 85 c8 00 00 00    	jne    801011ce <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101106:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101109:	31 f6                	xor    %esi,%esi
    while(i < n){
8010110b:	85 c0                	test   %eax,%eax
8010110d:	7f 30                	jg     8010113f <filewrite+0x6f>
8010110f:	e9 94 00 00 00       	jmp    801011a8 <filewrite+0xd8>
80101114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101118:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010111b:	83 ec 0c             	sub    $0xc,%esp
8010111e:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101121:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101124:	e8 57 07 00 00       	call   80101880 <iunlock>
      end_op();
80101129:	e8 c2 1c 00 00       	call   80102df0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010112e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101131:	83 c4 10             	add    $0x10,%esp
80101134:	39 c7                	cmp    %eax,%edi
80101136:	75 5c                	jne    80101194 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101138:	01 fe                	add    %edi,%esi
    while(i < n){
8010113a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010113d:	7e 69                	jle    801011a8 <filewrite+0xd8>
      int n1 = n - i;
8010113f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101142:	b8 00 06 00 00       	mov    $0x600,%eax
80101147:	29 f7                	sub    %esi,%edi
80101149:	39 c7                	cmp    %eax,%edi
8010114b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010114e:	e8 2d 1c 00 00       	call   80102d80 <begin_op>
      ilock(f->ip);
80101153:	83 ec 0c             	sub    $0xc,%esp
80101156:	ff 73 10             	push   0x10(%ebx)
80101159:	e8 42 06 00 00       	call   801017a0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010115e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101161:	57                   	push   %edi
80101162:	ff 73 14             	push   0x14(%ebx)
80101165:	01 f0                	add    %esi,%eax
80101167:	50                   	push   %eax
80101168:	ff 73 10             	push   0x10(%ebx)
8010116b:	e8 40 0a 00 00       	call   80101bb0 <writei>
80101170:	83 c4 20             	add    $0x20,%esp
80101173:	85 c0                	test   %eax,%eax
80101175:	7f a1                	jg     80101118 <filewrite+0x48>
      iunlock(f->ip);
80101177:	83 ec 0c             	sub    $0xc,%esp
8010117a:	ff 73 10             	push   0x10(%ebx)
8010117d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101180:	e8 fb 06 00 00       	call   80101880 <iunlock>
      end_op();
80101185:	e8 66 1c 00 00       	call   80102df0 <end_op>
      if(r < 0)
8010118a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010118d:	83 c4 10             	add    $0x10,%esp
80101190:	85 c0                	test   %eax,%eax
80101192:	75 1b                	jne    801011af <filewrite+0xdf>
        panic("short filewrite");
80101194:	83 ec 0c             	sub    $0xc,%esp
80101197:	68 4f 79 10 80       	push   $0x8010794f
8010119c:	e8 df f1 ff ff       	call   80100380 <panic>
801011a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
801011a8:	89 f0                	mov    %esi,%eax
801011aa:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
801011ad:	74 05                	je     801011b4 <filewrite+0xe4>
801011af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801011b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011b7:	5b                   	pop    %ebx
801011b8:	5e                   	pop    %esi
801011b9:	5f                   	pop    %edi
801011ba:	5d                   	pop    %ebp
801011bb:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801011bc:	8b 43 0c             	mov    0xc(%ebx),%eax
801011bf:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011c5:	5b                   	pop    %ebx
801011c6:	5e                   	pop    %esi
801011c7:	5f                   	pop    %edi
801011c8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011c9:	e9 22 24 00 00       	jmp    801035f0 <pipewrite>
  panic("filewrite");
801011ce:	83 ec 0c             	sub    $0xc,%esp
801011d1:	68 55 79 10 80       	push   $0x80107955
801011d6:	e8 a5 f1 ff ff       	call   80100380 <panic>
801011db:	66 90                	xchg   %ax,%ax
801011dd:	66 90                	xchg   %ax,%ax
801011df:	90                   	nop

801011e0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011e0:	55                   	push   %ebp
801011e1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011e3:	89 d0                	mov    %edx,%eax
801011e5:	c1 e8 0c             	shr    $0xc,%eax
801011e8:	03 05 cc 25 11 80    	add    0x801125cc,%eax
{
801011ee:	89 e5                	mov    %esp,%ebp
801011f0:	56                   	push   %esi
801011f1:	53                   	push   %ebx
801011f2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011f4:	83 ec 08             	sub    $0x8,%esp
801011f7:	50                   	push   %eax
801011f8:	51                   	push   %ecx
801011f9:	e8 d2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011fe:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101200:	c1 fb 03             	sar    $0x3,%ebx
80101203:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101206:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101208:	83 e1 07             	and    $0x7,%ecx
8010120b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101210:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101216:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101218:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010121d:	85 c1                	test   %eax,%ecx
8010121f:	74 23                	je     80101244 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101221:	f7 d0                	not    %eax
  log_write(bp);
80101223:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101226:	21 c8                	and    %ecx,%eax
80101228:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010122c:	56                   	push   %esi
8010122d:	e8 2e 1d 00 00       	call   80102f60 <log_write>
  brelse(bp);
80101232:	89 34 24             	mov    %esi,(%esp)
80101235:	e8 b6 ef ff ff       	call   801001f0 <brelse>
}
8010123a:	83 c4 10             	add    $0x10,%esp
8010123d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101240:	5b                   	pop    %ebx
80101241:	5e                   	pop    %esi
80101242:	5d                   	pop    %ebp
80101243:	c3                   	ret    
    panic("freeing free block");
80101244:	83 ec 0c             	sub    $0xc,%esp
80101247:	68 5f 79 10 80       	push   $0x8010795f
8010124c:	e8 2f f1 ff ff       	call   80100380 <panic>
80101251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101258:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010125f:	90                   	nop

80101260 <balloc>:
{
80101260:	55                   	push   %ebp
80101261:	89 e5                	mov    %esp,%ebp
80101263:	57                   	push   %edi
80101264:	56                   	push   %esi
80101265:	53                   	push   %ebx
80101266:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101269:	8b 0d b4 25 11 80    	mov    0x801125b4,%ecx
{
8010126f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101272:	85 c9                	test   %ecx,%ecx
80101274:	0f 84 87 00 00 00    	je     80101301 <balloc+0xa1>
8010127a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101281:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101284:	83 ec 08             	sub    $0x8,%esp
80101287:	89 f0                	mov    %esi,%eax
80101289:	c1 f8 0c             	sar    $0xc,%eax
8010128c:	03 05 cc 25 11 80    	add    0x801125cc,%eax
80101292:	50                   	push   %eax
80101293:	ff 75 d8             	push   -0x28(%ebp)
80101296:	e8 35 ee ff ff       	call   801000d0 <bread>
8010129b:	83 c4 10             	add    $0x10,%esp
8010129e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012a1:	a1 b4 25 11 80       	mov    0x801125b4,%eax
801012a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801012a9:	31 c0                	xor    %eax,%eax
801012ab:	eb 2f                	jmp    801012dc <balloc+0x7c>
801012ad:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801012b0:	89 c1                	mov    %eax,%ecx
801012b2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012b7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801012ba:	83 e1 07             	and    $0x7,%ecx
801012bd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012bf:	89 c1                	mov    %eax,%ecx
801012c1:	c1 f9 03             	sar    $0x3,%ecx
801012c4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012c9:	89 fa                	mov    %edi,%edx
801012cb:	85 df                	test   %ebx,%edi
801012cd:	74 41                	je     80101310 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012cf:	83 c0 01             	add    $0x1,%eax
801012d2:	83 c6 01             	add    $0x1,%esi
801012d5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012da:	74 05                	je     801012e1 <balloc+0x81>
801012dc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012df:	77 cf                	ja     801012b0 <balloc+0x50>
    brelse(bp);
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	ff 75 e4             	push   -0x1c(%ebp)
801012e7:	e8 04 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012ec:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012f3:	83 c4 10             	add    $0x10,%esp
801012f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012f9:	39 05 b4 25 11 80    	cmp    %eax,0x801125b4
801012ff:	77 80                	ja     80101281 <balloc+0x21>
  panic("balloc: out of blocks");
80101301:	83 ec 0c             	sub    $0xc,%esp
80101304:	68 72 79 10 80       	push   $0x80107972
80101309:	e8 72 f0 ff ff       	call   80100380 <panic>
8010130e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101310:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101313:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101316:	09 da                	or     %ebx,%edx
80101318:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010131c:	57                   	push   %edi
8010131d:	e8 3e 1c 00 00       	call   80102f60 <log_write>
        brelse(bp);
80101322:	89 3c 24             	mov    %edi,(%esp)
80101325:	e8 c6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010132a:	58                   	pop    %eax
8010132b:	5a                   	pop    %edx
8010132c:	56                   	push   %esi
8010132d:	ff 75 d8             	push   -0x28(%ebp)
80101330:	e8 9b ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101335:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101338:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010133a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010133d:	68 00 02 00 00       	push   $0x200
80101342:	6a 00                	push   $0x0
80101344:	50                   	push   %eax
80101345:	e8 16 38 00 00       	call   80104b60 <memset>
  log_write(bp);
8010134a:	89 1c 24             	mov    %ebx,(%esp)
8010134d:	e8 0e 1c 00 00       	call   80102f60 <log_write>
  brelse(bp);
80101352:	89 1c 24             	mov    %ebx,(%esp)
80101355:	e8 96 ee ff ff       	call   801001f0 <brelse>
}
8010135a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010135d:	89 f0                	mov    %esi,%eax
8010135f:	5b                   	pop    %ebx
80101360:	5e                   	pop    %esi
80101361:	5f                   	pop    %edi
80101362:	5d                   	pop    %ebp
80101363:	c3                   	ret    
80101364:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010136b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010136f:	90                   	nop

80101370 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101370:	55                   	push   %ebp
80101371:	89 e5                	mov    %esp,%ebp
80101373:	57                   	push   %edi
80101374:	89 c7                	mov    %eax,%edi
80101376:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101377:	31 f6                	xor    %esi,%esi
{
80101379:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010137a:	bb 94 09 11 80       	mov    $0x80110994,%ebx
{
8010137f:	83 ec 28             	sub    $0x28,%esp
80101382:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101385:	68 60 09 11 80       	push   $0x80110960
8010138a:	e8 11 37 00 00       	call   80104aa0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010138f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101392:	83 c4 10             	add    $0x10,%esp
80101395:	eb 1b                	jmp    801013b2 <iget+0x42>
80101397:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010139e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013a0:	39 3b                	cmp    %edi,(%ebx)
801013a2:	74 6c                	je     80101410 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013a4:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013aa:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801013b0:	73 26                	jae    801013d8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013b2:	8b 43 08             	mov    0x8(%ebx),%eax
801013b5:	85 c0                	test   %eax,%eax
801013b7:	7f e7                	jg     801013a0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801013b9:	85 f6                	test   %esi,%esi
801013bb:	75 e7                	jne    801013a4 <iget+0x34>
801013bd:	85 c0                	test   %eax,%eax
801013bf:	75 76                	jne    80101437 <iget+0xc7>
801013c1:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013c3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013c9:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801013cf:	72 e1                	jb     801013b2 <iget+0x42>
801013d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013d8:	85 f6                	test   %esi,%esi
801013da:	74 79                	je     80101455 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013dc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013df:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013e1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013e4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013eb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013f2:	68 60 09 11 80       	push   $0x80110960
801013f7:	e8 44 36 00 00       	call   80104a40 <release>

  return ip;
801013fc:	83 c4 10             	add    $0x10,%esp
}
801013ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101402:	89 f0                	mov    %esi,%eax
80101404:	5b                   	pop    %ebx
80101405:	5e                   	pop    %esi
80101406:	5f                   	pop    %edi
80101407:	5d                   	pop    %ebp
80101408:	c3                   	ret    
80101409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101410:	39 53 04             	cmp    %edx,0x4(%ebx)
80101413:	75 8f                	jne    801013a4 <iget+0x34>
      release(&icache.lock);
80101415:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101418:	83 c0 01             	add    $0x1,%eax
      return ip;
8010141b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010141d:	68 60 09 11 80       	push   $0x80110960
      ip->ref++;
80101422:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101425:	e8 16 36 00 00       	call   80104a40 <release>
      return ip;
8010142a:	83 c4 10             	add    $0x10,%esp
}
8010142d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101430:	89 f0                	mov    %esi,%eax
80101432:	5b                   	pop    %ebx
80101433:	5e                   	pop    %esi
80101434:	5f                   	pop    %edi
80101435:	5d                   	pop    %ebp
80101436:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101437:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010143d:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101443:	73 10                	jae    80101455 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101445:	8b 43 08             	mov    0x8(%ebx),%eax
80101448:	85 c0                	test   %eax,%eax
8010144a:	0f 8f 50 ff ff ff    	jg     801013a0 <iget+0x30>
80101450:	e9 68 ff ff ff       	jmp    801013bd <iget+0x4d>
    panic("iget: no inodes");
80101455:	83 ec 0c             	sub    $0xc,%esp
80101458:	68 88 79 10 80       	push   $0x80107988
8010145d:	e8 1e ef ff ff       	call   80100380 <panic>
80101462:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101470 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	57                   	push   %edi
80101474:	56                   	push   %esi
80101475:	89 c6                	mov    %eax,%esi
80101477:	53                   	push   %ebx
80101478:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010147b:	83 fa 0b             	cmp    $0xb,%edx
8010147e:	0f 86 8c 00 00 00    	jbe    80101510 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101484:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101487:	83 fb 7f             	cmp    $0x7f,%ebx
8010148a:	0f 87 a2 00 00 00    	ja     80101532 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101490:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101496:	85 c0                	test   %eax,%eax
80101498:	74 5e                	je     801014f8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010149a:	83 ec 08             	sub    $0x8,%esp
8010149d:	50                   	push   %eax
8010149e:	ff 36                	push   (%esi)
801014a0:	e8 2b ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801014a5:	83 c4 10             	add    $0x10,%esp
801014a8:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
801014ac:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
801014ae:	8b 3b                	mov    (%ebx),%edi
801014b0:	85 ff                	test   %edi,%edi
801014b2:	74 1c                	je     801014d0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801014b4:	83 ec 0c             	sub    $0xc,%esp
801014b7:	52                   	push   %edx
801014b8:	e8 33 ed ff ff       	call   801001f0 <brelse>
801014bd:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014c3:	89 f8                	mov    %edi,%eax
801014c5:	5b                   	pop    %ebx
801014c6:	5e                   	pop    %esi
801014c7:	5f                   	pop    %edi
801014c8:	5d                   	pop    %ebp
801014c9:	c3                   	ret    
801014ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801014d3:	8b 06                	mov    (%esi),%eax
801014d5:	e8 86 fd ff ff       	call   80101260 <balloc>
      log_write(bp);
801014da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014dd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014e0:	89 03                	mov    %eax,(%ebx)
801014e2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801014e4:	52                   	push   %edx
801014e5:	e8 76 1a 00 00       	call   80102f60 <log_write>
801014ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014ed:	83 c4 10             	add    $0x10,%esp
801014f0:	eb c2                	jmp    801014b4 <bmap+0x44>
801014f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014f8:	8b 06                	mov    (%esi),%eax
801014fa:	e8 61 fd ff ff       	call   80101260 <balloc>
801014ff:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101505:	eb 93                	jmp    8010149a <bmap+0x2a>
80101507:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010150e:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
80101510:	8d 5a 14             	lea    0x14(%edx),%ebx
80101513:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101517:	85 ff                	test   %edi,%edi
80101519:	75 a5                	jne    801014c0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010151b:	8b 00                	mov    (%eax),%eax
8010151d:	e8 3e fd ff ff       	call   80101260 <balloc>
80101522:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101526:	89 c7                	mov    %eax,%edi
}
80101528:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010152b:	5b                   	pop    %ebx
8010152c:	89 f8                	mov    %edi,%eax
8010152e:	5e                   	pop    %esi
8010152f:	5f                   	pop    %edi
80101530:	5d                   	pop    %ebp
80101531:	c3                   	ret    
  panic("bmap: out of range");
80101532:	83 ec 0c             	sub    $0xc,%esp
80101535:	68 98 79 10 80       	push   $0x80107998
8010153a:	e8 41 ee ff ff       	call   80100380 <panic>
8010153f:	90                   	nop

80101540 <readsb>:
{
80101540:	55                   	push   %ebp
80101541:	89 e5                	mov    %esp,%ebp
80101543:	56                   	push   %esi
80101544:	53                   	push   %ebx
80101545:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101548:	83 ec 08             	sub    $0x8,%esp
8010154b:	6a 01                	push   $0x1
8010154d:	ff 75 08             	push   0x8(%ebp)
80101550:	e8 7b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101555:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101558:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010155a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010155d:	6a 1c                	push   $0x1c
8010155f:	50                   	push   %eax
80101560:	56                   	push   %esi
80101561:	e8 9a 36 00 00       	call   80104c00 <memmove>
  brelse(bp);
80101566:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101569:	83 c4 10             	add    $0x10,%esp
}
8010156c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010156f:	5b                   	pop    %ebx
80101570:	5e                   	pop    %esi
80101571:	5d                   	pop    %ebp
  brelse(bp);
80101572:	e9 79 ec ff ff       	jmp    801001f0 <brelse>
80101577:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010157e:	66 90                	xchg   %ax,%ax

80101580 <iinit>:
{
80101580:	55                   	push   %ebp
80101581:	89 e5                	mov    %esp,%ebp
80101583:	53                   	push   %ebx
80101584:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
80101589:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010158c:	68 ab 79 10 80       	push   $0x801079ab
80101591:	68 60 09 11 80       	push   $0x80110960
80101596:	e8 35 33 00 00       	call   801048d0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010159b:	83 c4 10             	add    $0x10,%esp
8010159e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801015a0:	83 ec 08             	sub    $0x8,%esp
801015a3:	68 b2 79 10 80       	push   $0x801079b2
801015a8:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
801015a9:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
801015af:	e8 ec 31 00 00       	call   801047a0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801015b4:	83 c4 10             	add    $0x10,%esp
801015b7:	81 fb c0 25 11 80    	cmp    $0x801125c0,%ebx
801015bd:	75 e1                	jne    801015a0 <iinit+0x20>
  bp = bread(dev, 1);
801015bf:	83 ec 08             	sub    $0x8,%esp
801015c2:	6a 01                	push   $0x1
801015c4:	ff 75 08             	push   0x8(%ebp)
801015c7:	e8 04 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015cc:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015cf:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015d1:	8d 40 5c             	lea    0x5c(%eax),%eax
801015d4:	6a 1c                	push   $0x1c
801015d6:	50                   	push   %eax
801015d7:	68 b4 25 11 80       	push   $0x801125b4
801015dc:	e8 1f 36 00 00       	call   80104c00 <memmove>
  brelse(bp);
801015e1:	89 1c 24             	mov    %ebx,(%esp)
801015e4:	e8 07 ec ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015e9:	ff 35 cc 25 11 80    	push   0x801125cc
801015ef:	ff 35 c8 25 11 80    	push   0x801125c8
801015f5:	ff 35 c4 25 11 80    	push   0x801125c4
801015fb:	ff 35 c0 25 11 80    	push   0x801125c0
80101601:	ff 35 bc 25 11 80    	push   0x801125bc
80101607:	ff 35 b8 25 11 80    	push   0x801125b8
8010160d:	ff 35 b4 25 11 80    	push   0x801125b4
80101613:	68 18 7a 10 80       	push   $0x80107a18
80101618:	e8 83 f0 ff ff       	call   801006a0 <cprintf>
}
8010161d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101620:	83 c4 30             	add    $0x30,%esp
80101623:	c9                   	leave  
80101624:	c3                   	ret    
80101625:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010162c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101630 <ialloc>:
{
80101630:	55                   	push   %ebp
80101631:	89 e5                	mov    %esp,%ebp
80101633:	57                   	push   %edi
80101634:	56                   	push   %esi
80101635:	53                   	push   %ebx
80101636:	83 ec 1c             	sub    $0x1c,%esp
80101639:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010163c:	83 3d bc 25 11 80 01 	cmpl   $0x1,0x801125bc
{
80101643:	8b 75 08             	mov    0x8(%ebp),%esi
80101646:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101649:	0f 86 91 00 00 00    	jbe    801016e0 <ialloc+0xb0>
8010164f:	bf 01 00 00 00       	mov    $0x1,%edi
80101654:	eb 21                	jmp    80101677 <ialloc+0x47>
80101656:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010165d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101660:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101663:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101666:	53                   	push   %ebx
80101667:	e8 84 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010166c:	83 c4 10             	add    $0x10,%esp
8010166f:	3b 3d bc 25 11 80    	cmp    0x801125bc,%edi
80101675:	73 69                	jae    801016e0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101677:	89 f8                	mov    %edi,%eax
80101679:	83 ec 08             	sub    $0x8,%esp
8010167c:	c1 e8 03             	shr    $0x3,%eax
8010167f:	03 05 c8 25 11 80    	add    0x801125c8,%eax
80101685:	50                   	push   %eax
80101686:	56                   	push   %esi
80101687:	e8 44 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010168c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010168f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101691:	89 f8                	mov    %edi,%eax
80101693:	83 e0 07             	and    $0x7,%eax
80101696:	c1 e0 06             	shl    $0x6,%eax
80101699:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010169d:	66 83 39 00          	cmpw   $0x0,(%ecx)
801016a1:	75 bd                	jne    80101660 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801016a3:	83 ec 04             	sub    $0x4,%esp
801016a6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801016a9:	6a 40                	push   $0x40
801016ab:	6a 00                	push   $0x0
801016ad:	51                   	push   %ecx
801016ae:	e8 ad 34 00 00       	call   80104b60 <memset>
      dip->type = type;
801016b3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801016b7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801016ba:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801016bd:	89 1c 24             	mov    %ebx,(%esp)
801016c0:	e8 9b 18 00 00       	call   80102f60 <log_write>
      brelse(bp);
801016c5:	89 1c 24             	mov    %ebx,(%esp)
801016c8:	e8 23 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016cd:	83 c4 10             	add    $0x10,%esp
}
801016d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016d3:	89 fa                	mov    %edi,%edx
}
801016d5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016d6:	89 f0                	mov    %esi,%eax
}
801016d8:	5e                   	pop    %esi
801016d9:	5f                   	pop    %edi
801016da:	5d                   	pop    %ebp
      return iget(dev, inum);
801016db:	e9 90 fc ff ff       	jmp    80101370 <iget>
  panic("ialloc: no inodes");
801016e0:	83 ec 0c             	sub    $0xc,%esp
801016e3:	68 b8 79 10 80       	push   $0x801079b8
801016e8:	e8 93 ec ff ff       	call   80100380 <panic>
801016ed:	8d 76 00             	lea    0x0(%esi),%esi

801016f0 <iupdate>:
{
801016f0:	55                   	push   %ebp
801016f1:	89 e5                	mov    %esp,%ebp
801016f3:	56                   	push   %esi
801016f4:	53                   	push   %ebx
801016f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016f8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016fb:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016fe:	83 ec 08             	sub    $0x8,%esp
80101701:	c1 e8 03             	shr    $0x3,%eax
80101704:	03 05 c8 25 11 80    	add    0x801125c8,%eax
8010170a:	50                   	push   %eax
8010170b:	ff 73 a4             	push   -0x5c(%ebx)
8010170e:	e8 bd e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101713:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101717:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010171a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010171c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010171f:	83 e0 07             	and    $0x7,%eax
80101722:	c1 e0 06             	shl    $0x6,%eax
80101725:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101729:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010172c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101730:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101733:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101737:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010173b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010173f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101743:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101747:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010174a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010174d:	6a 34                	push   $0x34
8010174f:	53                   	push   %ebx
80101750:	50                   	push   %eax
80101751:	e8 aa 34 00 00       	call   80104c00 <memmove>
  log_write(bp);
80101756:	89 34 24             	mov    %esi,(%esp)
80101759:	e8 02 18 00 00       	call   80102f60 <log_write>
  brelse(bp);
8010175e:	89 75 08             	mov    %esi,0x8(%ebp)
80101761:	83 c4 10             	add    $0x10,%esp
}
80101764:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101767:	5b                   	pop    %ebx
80101768:	5e                   	pop    %esi
80101769:	5d                   	pop    %ebp
  brelse(bp);
8010176a:	e9 81 ea ff ff       	jmp    801001f0 <brelse>
8010176f:	90                   	nop

80101770 <idup>:
{
80101770:	55                   	push   %ebp
80101771:	89 e5                	mov    %esp,%ebp
80101773:	53                   	push   %ebx
80101774:	83 ec 10             	sub    $0x10,%esp
80101777:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010177a:	68 60 09 11 80       	push   $0x80110960
8010177f:	e8 1c 33 00 00       	call   80104aa0 <acquire>
  ip->ref++;
80101784:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101788:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010178f:	e8 ac 32 00 00       	call   80104a40 <release>
}
80101794:	89 d8                	mov    %ebx,%eax
80101796:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101799:	c9                   	leave  
8010179a:	c3                   	ret    
8010179b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010179f:	90                   	nop

801017a0 <ilock>:
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	56                   	push   %esi
801017a4:	53                   	push   %ebx
801017a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801017a8:	85 db                	test   %ebx,%ebx
801017aa:	0f 84 b7 00 00 00    	je     80101867 <ilock+0xc7>
801017b0:	8b 53 08             	mov    0x8(%ebx),%edx
801017b3:	85 d2                	test   %edx,%edx
801017b5:	0f 8e ac 00 00 00    	jle    80101867 <ilock+0xc7>
  acquiresleep(&ip->lock);
801017bb:	83 ec 0c             	sub    $0xc,%esp
801017be:	8d 43 0c             	lea    0xc(%ebx),%eax
801017c1:	50                   	push   %eax
801017c2:	e8 19 30 00 00       	call   801047e0 <acquiresleep>
  if(ip->valid == 0){
801017c7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017ca:	83 c4 10             	add    $0x10,%esp
801017cd:	85 c0                	test   %eax,%eax
801017cf:	74 0f                	je     801017e0 <ilock+0x40>
}
801017d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017d4:	5b                   	pop    %ebx
801017d5:	5e                   	pop    %esi
801017d6:	5d                   	pop    %ebp
801017d7:	c3                   	ret    
801017d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017df:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017e0:	8b 43 04             	mov    0x4(%ebx),%eax
801017e3:	83 ec 08             	sub    $0x8,%esp
801017e6:	c1 e8 03             	shr    $0x3,%eax
801017e9:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801017ef:	50                   	push   %eax
801017f0:	ff 33                	push   (%ebx)
801017f2:	e8 d9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017f7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017fa:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017fc:	8b 43 04             	mov    0x4(%ebx),%eax
801017ff:	83 e0 07             	and    $0x7,%eax
80101802:	c1 e0 06             	shl    $0x6,%eax
80101805:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101809:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010180c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010180f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101813:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101817:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010181b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010181f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101823:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101827:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010182b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010182e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101831:	6a 34                	push   $0x34
80101833:	50                   	push   %eax
80101834:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101837:	50                   	push   %eax
80101838:	e8 c3 33 00 00       	call   80104c00 <memmove>
    brelse(bp);
8010183d:	89 34 24             	mov    %esi,(%esp)
80101840:	e8 ab e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101845:	83 c4 10             	add    $0x10,%esp
80101848:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010184d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101854:	0f 85 77 ff ff ff    	jne    801017d1 <ilock+0x31>
      panic("ilock: no type");
8010185a:	83 ec 0c             	sub    $0xc,%esp
8010185d:	68 d0 79 10 80       	push   $0x801079d0
80101862:	e8 19 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101867:	83 ec 0c             	sub    $0xc,%esp
8010186a:	68 ca 79 10 80       	push   $0x801079ca
8010186f:	e8 0c eb ff ff       	call   80100380 <panic>
80101874:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010187b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010187f:	90                   	nop

80101880 <iunlock>:
{
80101880:	55                   	push   %ebp
80101881:	89 e5                	mov    %esp,%ebp
80101883:	56                   	push   %esi
80101884:	53                   	push   %ebx
80101885:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101888:	85 db                	test   %ebx,%ebx
8010188a:	74 28                	je     801018b4 <iunlock+0x34>
8010188c:	83 ec 0c             	sub    $0xc,%esp
8010188f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101892:	56                   	push   %esi
80101893:	e8 e8 2f 00 00       	call   80104880 <holdingsleep>
80101898:	83 c4 10             	add    $0x10,%esp
8010189b:	85 c0                	test   %eax,%eax
8010189d:	74 15                	je     801018b4 <iunlock+0x34>
8010189f:	8b 43 08             	mov    0x8(%ebx),%eax
801018a2:	85 c0                	test   %eax,%eax
801018a4:	7e 0e                	jle    801018b4 <iunlock+0x34>
  releasesleep(&ip->lock);
801018a6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801018a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018ac:	5b                   	pop    %ebx
801018ad:	5e                   	pop    %esi
801018ae:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801018af:	e9 8c 2f 00 00       	jmp    80104840 <releasesleep>
    panic("iunlock");
801018b4:	83 ec 0c             	sub    $0xc,%esp
801018b7:	68 df 79 10 80       	push   $0x801079df
801018bc:	e8 bf ea ff ff       	call   80100380 <panic>
801018c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018cf:	90                   	nop

801018d0 <iput>:
{
801018d0:	55                   	push   %ebp
801018d1:	89 e5                	mov    %esp,%ebp
801018d3:	57                   	push   %edi
801018d4:	56                   	push   %esi
801018d5:	53                   	push   %ebx
801018d6:	83 ec 28             	sub    $0x28,%esp
801018d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018dc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018df:	57                   	push   %edi
801018e0:	e8 fb 2e 00 00       	call   801047e0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018e5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018e8:	83 c4 10             	add    $0x10,%esp
801018eb:	85 d2                	test   %edx,%edx
801018ed:	74 07                	je     801018f6 <iput+0x26>
801018ef:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018f4:	74 32                	je     80101928 <iput+0x58>
  releasesleep(&ip->lock);
801018f6:	83 ec 0c             	sub    $0xc,%esp
801018f9:	57                   	push   %edi
801018fa:	e8 41 2f 00 00       	call   80104840 <releasesleep>
  acquire(&icache.lock);
801018ff:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101906:	e8 95 31 00 00       	call   80104aa0 <acquire>
  ip->ref--;
8010190b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010190f:	83 c4 10             	add    $0x10,%esp
80101912:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
}
80101919:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010191c:	5b                   	pop    %ebx
8010191d:	5e                   	pop    %esi
8010191e:	5f                   	pop    %edi
8010191f:	5d                   	pop    %ebp
  release(&icache.lock);
80101920:	e9 1b 31 00 00       	jmp    80104a40 <release>
80101925:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101928:	83 ec 0c             	sub    $0xc,%esp
8010192b:	68 60 09 11 80       	push   $0x80110960
80101930:	e8 6b 31 00 00       	call   80104aa0 <acquire>
    int r = ip->ref;
80101935:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101938:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010193f:	e8 fc 30 00 00       	call   80104a40 <release>
    if(r == 1){
80101944:	83 c4 10             	add    $0x10,%esp
80101947:	83 fe 01             	cmp    $0x1,%esi
8010194a:	75 aa                	jne    801018f6 <iput+0x26>
8010194c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101952:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101955:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101958:	89 cf                	mov    %ecx,%edi
8010195a:	eb 0b                	jmp    80101967 <iput+0x97>
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101960:	83 c6 04             	add    $0x4,%esi
80101963:	39 fe                	cmp    %edi,%esi
80101965:	74 19                	je     80101980 <iput+0xb0>
    if(ip->addrs[i]){
80101967:	8b 16                	mov    (%esi),%edx
80101969:	85 d2                	test   %edx,%edx
8010196b:	74 f3                	je     80101960 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010196d:	8b 03                	mov    (%ebx),%eax
8010196f:	e8 6c f8 ff ff       	call   801011e0 <bfree>
      ip->addrs[i] = 0;
80101974:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010197a:	eb e4                	jmp    80101960 <iput+0x90>
8010197c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101980:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101986:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101989:	85 c0                	test   %eax,%eax
8010198b:	75 2d                	jne    801019ba <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010198d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101990:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101997:	53                   	push   %ebx
80101998:	e8 53 fd ff ff       	call   801016f0 <iupdate>
      ip->type = 0;
8010199d:	31 c0                	xor    %eax,%eax
8010199f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801019a3:	89 1c 24             	mov    %ebx,(%esp)
801019a6:	e8 45 fd ff ff       	call   801016f0 <iupdate>
      ip->valid = 0;
801019ab:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801019b2:	83 c4 10             	add    $0x10,%esp
801019b5:	e9 3c ff ff ff       	jmp    801018f6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801019ba:	83 ec 08             	sub    $0x8,%esp
801019bd:	50                   	push   %eax
801019be:	ff 33                	push   (%ebx)
801019c0:	e8 0b e7 ff ff       	call   801000d0 <bread>
801019c5:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019c8:	83 c4 10             	add    $0x10,%esp
801019cb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019d4:	8d 70 5c             	lea    0x5c(%eax),%esi
801019d7:	89 cf                	mov    %ecx,%edi
801019d9:	eb 0c                	jmp    801019e7 <iput+0x117>
801019db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019df:	90                   	nop
801019e0:	83 c6 04             	add    $0x4,%esi
801019e3:	39 f7                	cmp    %esi,%edi
801019e5:	74 0f                	je     801019f6 <iput+0x126>
      if(a[j])
801019e7:	8b 16                	mov    (%esi),%edx
801019e9:	85 d2                	test   %edx,%edx
801019eb:	74 f3                	je     801019e0 <iput+0x110>
        bfree(ip->dev, a[j]);
801019ed:	8b 03                	mov    (%ebx),%eax
801019ef:	e8 ec f7 ff ff       	call   801011e0 <bfree>
801019f4:	eb ea                	jmp    801019e0 <iput+0x110>
    brelse(bp);
801019f6:	83 ec 0c             	sub    $0xc,%esp
801019f9:	ff 75 e4             	push   -0x1c(%ebp)
801019fc:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019ff:	e8 ec e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a04:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a0a:	8b 03                	mov    (%ebx),%eax
80101a0c:	e8 cf f7 ff ff       	call   801011e0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a11:	83 c4 10             	add    $0x10,%esp
80101a14:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a1b:	00 00 00 
80101a1e:	e9 6a ff ff ff       	jmp    8010198d <iput+0xbd>
80101a23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a30 <iunlockput>:
{
80101a30:	55                   	push   %ebp
80101a31:	89 e5                	mov    %esp,%ebp
80101a33:	56                   	push   %esi
80101a34:	53                   	push   %ebx
80101a35:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a38:	85 db                	test   %ebx,%ebx
80101a3a:	74 34                	je     80101a70 <iunlockput+0x40>
80101a3c:	83 ec 0c             	sub    $0xc,%esp
80101a3f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a42:	56                   	push   %esi
80101a43:	e8 38 2e 00 00       	call   80104880 <holdingsleep>
80101a48:	83 c4 10             	add    $0x10,%esp
80101a4b:	85 c0                	test   %eax,%eax
80101a4d:	74 21                	je     80101a70 <iunlockput+0x40>
80101a4f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a52:	85 c0                	test   %eax,%eax
80101a54:	7e 1a                	jle    80101a70 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a56:	83 ec 0c             	sub    $0xc,%esp
80101a59:	56                   	push   %esi
80101a5a:	e8 e1 2d 00 00       	call   80104840 <releasesleep>
  iput(ip);
80101a5f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a62:	83 c4 10             	add    $0x10,%esp
}
80101a65:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a68:	5b                   	pop    %ebx
80101a69:	5e                   	pop    %esi
80101a6a:	5d                   	pop    %ebp
  iput(ip);
80101a6b:	e9 60 fe ff ff       	jmp    801018d0 <iput>
    panic("iunlock");
80101a70:	83 ec 0c             	sub    $0xc,%esp
80101a73:	68 df 79 10 80       	push   $0x801079df
80101a78:	e8 03 e9 ff ff       	call   80100380 <panic>
80101a7d:	8d 76 00             	lea    0x0(%esi),%esi

80101a80 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a80:	55                   	push   %ebp
80101a81:	89 e5                	mov    %esp,%ebp
80101a83:	8b 55 08             	mov    0x8(%ebp),%edx
80101a86:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a89:	8b 0a                	mov    (%edx),%ecx
80101a8b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a8e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a91:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a94:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a98:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a9b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a9f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101aa3:	8b 52 58             	mov    0x58(%edx),%edx
80101aa6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101aa9:	5d                   	pop    %ebp
80101aaa:	c3                   	ret    
80101aab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aaf:	90                   	nop

80101ab0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101ab0:	55                   	push   %ebp
80101ab1:	89 e5                	mov    %esp,%ebp
80101ab3:	57                   	push   %edi
80101ab4:	56                   	push   %esi
80101ab5:	53                   	push   %ebx
80101ab6:	83 ec 1c             	sub    $0x1c,%esp
80101ab9:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101abc:	8b 45 08             	mov    0x8(%ebp),%eax
80101abf:	8b 75 10             	mov    0x10(%ebp),%esi
80101ac2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101ac5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ac8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101acd:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ad0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101ad3:	0f 84 a7 00 00 00    	je     80101b80 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ad9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101adc:	8b 40 58             	mov    0x58(%eax),%eax
80101adf:	39 c6                	cmp    %eax,%esi
80101ae1:	0f 87 ba 00 00 00    	ja     80101ba1 <readi+0xf1>
80101ae7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101aea:	31 c9                	xor    %ecx,%ecx
80101aec:	89 da                	mov    %ebx,%edx
80101aee:	01 f2                	add    %esi,%edx
80101af0:	0f 92 c1             	setb   %cl
80101af3:	89 cf                	mov    %ecx,%edi
80101af5:	0f 82 a6 00 00 00    	jb     80101ba1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101afb:	89 c1                	mov    %eax,%ecx
80101afd:	29 f1                	sub    %esi,%ecx
80101aff:	39 d0                	cmp    %edx,%eax
80101b01:	0f 43 cb             	cmovae %ebx,%ecx
80101b04:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b07:	85 c9                	test   %ecx,%ecx
80101b09:	74 67                	je     80101b72 <readi+0xc2>
80101b0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b0f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b10:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b13:	89 f2                	mov    %esi,%edx
80101b15:	c1 ea 09             	shr    $0x9,%edx
80101b18:	89 d8                	mov    %ebx,%eax
80101b1a:	e8 51 f9 ff ff       	call   80101470 <bmap>
80101b1f:	83 ec 08             	sub    $0x8,%esp
80101b22:	50                   	push   %eax
80101b23:	ff 33                	push   (%ebx)
80101b25:	e8 a6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b2a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b2d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b32:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b34:	89 f0                	mov    %esi,%eax
80101b36:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b3b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b3d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b40:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b42:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b46:	39 d9                	cmp    %ebx,%ecx
80101b48:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b4b:	83 c4 0c             	add    $0xc,%esp
80101b4e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b4f:	01 df                	add    %ebx,%edi
80101b51:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b53:	50                   	push   %eax
80101b54:	ff 75 e0             	push   -0x20(%ebp)
80101b57:	e8 a4 30 00 00       	call   80104c00 <memmove>
    brelse(bp);
80101b5c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b5f:	89 14 24             	mov    %edx,(%esp)
80101b62:	e8 89 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b67:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b6a:	83 c4 10             	add    $0x10,%esp
80101b6d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b70:	77 9e                	ja     80101b10 <readi+0x60>
  }
  return n;
80101b72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b78:	5b                   	pop    %ebx
80101b79:	5e                   	pop    %esi
80101b7a:	5f                   	pop    %edi
80101b7b:	5d                   	pop    %ebp
80101b7c:	c3                   	ret    
80101b7d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b80:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b84:	66 83 f8 09          	cmp    $0x9,%ax
80101b88:	77 17                	ja     80101ba1 <readi+0xf1>
80101b8a:	8b 04 c5 00 09 11 80 	mov    -0x7feef700(,%eax,8),%eax
80101b91:	85 c0                	test   %eax,%eax
80101b93:	74 0c                	je     80101ba1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b95:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b9b:	5b                   	pop    %ebx
80101b9c:	5e                   	pop    %esi
80101b9d:	5f                   	pop    %edi
80101b9e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b9f:	ff e0                	jmp    *%eax
      return -1;
80101ba1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ba6:	eb cd                	jmp    80101b75 <readi+0xc5>
80101ba8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101baf:	90                   	nop

80101bb0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	57                   	push   %edi
80101bb4:	56                   	push   %esi
80101bb5:	53                   	push   %ebx
80101bb6:	83 ec 1c             	sub    $0x1c,%esp
80101bb9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bbc:	8b 75 0c             	mov    0xc(%ebp),%esi
80101bbf:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bc2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101bc7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101bca:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bcd:	8b 75 10             	mov    0x10(%ebp),%esi
80101bd0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101bd3:	0f 84 b7 00 00 00    	je     80101c90 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bd9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bdc:	3b 70 58             	cmp    0x58(%eax),%esi
80101bdf:	0f 87 e7 00 00 00    	ja     80101ccc <writei+0x11c>
80101be5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101be8:	31 d2                	xor    %edx,%edx
80101bea:	89 f8                	mov    %edi,%eax
80101bec:	01 f0                	add    %esi,%eax
80101bee:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101bf1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bf6:	0f 87 d0 00 00 00    	ja     80101ccc <writei+0x11c>
80101bfc:	85 d2                	test   %edx,%edx
80101bfe:	0f 85 c8 00 00 00    	jne    80101ccc <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c04:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101c0b:	85 ff                	test   %edi,%edi
80101c0d:	74 72                	je     80101c81 <writei+0xd1>
80101c0f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c10:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101c13:	89 f2                	mov    %esi,%edx
80101c15:	c1 ea 09             	shr    $0x9,%edx
80101c18:	89 f8                	mov    %edi,%eax
80101c1a:	e8 51 f8 ff ff       	call   80101470 <bmap>
80101c1f:	83 ec 08             	sub    $0x8,%esp
80101c22:	50                   	push   %eax
80101c23:	ff 37                	push   (%edi)
80101c25:	e8 a6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c2a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c2f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c32:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c35:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c37:	89 f0                	mov    %esi,%eax
80101c39:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c3e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c40:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c44:	39 d9                	cmp    %ebx,%ecx
80101c46:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c49:	83 c4 0c             	add    $0xc,%esp
80101c4c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c4d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c4f:	ff 75 dc             	push   -0x24(%ebp)
80101c52:	50                   	push   %eax
80101c53:	e8 a8 2f 00 00       	call   80104c00 <memmove>
    log_write(bp);
80101c58:	89 3c 24             	mov    %edi,(%esp)
80101c5b:	e8 00 13 00 00       	call   80102f60 <log_write>
    brelse(bp);
80101c60:	89 3c 24             	mov    %edi,(%esp)
80101c63:	e8 88 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c68:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c6b:	83 c4 10             	add    $0x10,%esp
80101c6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c71:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c74:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c77:	77 97                	ja     80101c10 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c79:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c7c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c7f:	77 37                	ja     80101cb8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c81:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c84:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c87:	5b                   	pop    %ebx
80101c88:	5e                   	pop    %esi
80101c89:	5f                   	pop    %edi
80101c8a:	5d                   	pop    %ebp
80101c8b:	c3                   	ret    
80101c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c90:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c94:	66 83 f8 09          	cmp    $0x9,%ax
80101c98:	77 32                	ja     80101ccc <writei+0x11c>
80101c9a:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
80101ca1:	85 c0                	test   %eax,%eax
80101ca3:	74 27                	je     80101ccc <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101ca5:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101ca8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cab:	5b                   	pop    %ebx
80101cac:	5e                   	pop    %esi
80101cad:	5f                   	pop    %edi
80101cae:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101caf:	ff e0                	jmp    *%eax
80101cb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101cb8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101cbb:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101cbe:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101cc1:	50                   	push   %eax
80101cc2:	e8 29 fa ff ff       	call   801016f0 <iupdate>
80101cc7:	83 c4 10             	add    $0x10,%esp
80101cca:	eb b5                	jmp    80101c81 <writei+0xd1>
      return -1;
80101ccc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cd1:	eb b1                	jmp    80101c84 <writei+0xd4>
80101cd3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101ce0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101ce0:	55                   	push   %ebp
80101ce1:	89 e5                	mov    %esp,%ebp
80101ce3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101ce6:	6a 0e                	push   $0xe
80101ce8:	ff 75 0c             	push   0xc(%ebp)
80101ceb:	ff 75 08             	push   0x8(%ebp)
80101cee:	e8 7d 2f 00 00       	call   80104c70 <strncmp>
}
80101cf3:	c9                   	leave  
80101cf4:	c3                   	ret    
80101cf5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101d00 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101d00:	55                   	push   %ebp
80101d01:	89 e5                	mov    %esp,%ebp
80101d03:	57                   	push   %edi
80101d04:	56                   	push   %esi
80101d05:	53                   	push   %ebx
80101d06:	83 ec 1c             	sub    $0x1c,%esp
80101d09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101d0c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d11:	0f 85 85 00 00 00    	jne    80101d9c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d17:	8b 53 58             	mov    0x58(%ebx),%edx
80101d1a:	31 ff                	xor    %edi,%edi
80101d1c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d1f:	85 d2                	test   %edx,%edx
80101d21:	74 3e                	je     80101d61 <dirlookup+0x61>
80101d23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d27:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d28:	6a 10                	push   $0x10
80101d2a:	57                   	push   %edi
80101d2b:	56                   	push   %esi
80101d2c:	53                   	push   %ebx
80101d2d:	e8 7e fd ff ff       	call   80101ab0 <readi>
80101d32:	83 c4 10             	add    $0x10,%esp
80101d35:	83 f8 10             	cmp    $0x10,%eax
80101d38:	75 55                	jne    80101d8f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d3a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d3f:	74 18                	je     80101d59 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d41:	83 ec 04             	sub    $0x4,%esp
80101d44:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d47:	6a 0e                	push   $0xe
80101d49:	50                   	push   %eax
80101d4a:	ff 75 0c             	push   0xc(%ebp)
80101d4d:	e8 1e 2f 00 00       	call   80104c70 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d52:	83 c4 10             	add    $0x10,%esp
80101d55:	85 c0                	test   %eax,%eax
80101d57:	74 17                	je     80101d70 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d59:	83 c7 10             	add    $0x10,%edi
80101d5c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d5f:	72 c7                	jb     80101d28 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d61:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d64:	31 c0                	xor    %eax,%eax
}
80101d66:	5b                   	pop    %ebx
80101d67:	5e                   	pop    %esi
80101d68:	5f                   	pop    %edi
80101d69:	5d                   	pop    %ebp
80101d6a:	c3                   	ret    
80101d6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d6f:	90                   	nop
      if(poff)
80101d70:	8b 45 10             	mov    0x10(%ebp),%eax
80101d73:	85 c0                	test   %eax,%eax
80101d75:	74 05                	je     80101d7c <dirlookup+0x7c>
        *poff = off;
80101d77:	8b 45 10             	mov    0x10(%ebp),%eax
80101d7a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d7c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d80:	8b 03                	mov    (%ebx),%eax
80101d82:	e8 e9 f5 ff ff       	call   80101370 <iget>
}
80101d87:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d8a:	5b                   	pop    %ebx
80101d8b:	5e                   	pop    %esi
80101d8c:	5f                   	pop    %edi
80101d8d:	5d                   	pop    %ebp
80101d8e:	c3                   	ret    
      panic("dirlookup read");
80101d8f:	83 ec 0c             	sub    $0xc,%esp
80101d92:	68 f9 79 10 80       	push   $0x801079f9
80101d97:	e8 e4 e5 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d9c:	83 ec 0c             	sub    $0xc,%esp
80101d9f:	68 e7 79 10 80       	push   $0x801079e7
80101da4:	e8 d7 e5 ff ff       	call   80100380 <panic>
80101da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101db0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101db0:	55                   	push   %ebp
80101db1:	89 e5                	mov    %esp,%ebp
80101db3:	57                   	push   %edi
80101db4:	56                   	push   %esi
80101db5:	53                   	push   %ebx
80101db6:	89 c3                	mov    %eax,%ebx
80101db8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101dbb:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101dbe:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101dc1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101dc4:	0f 84 64 01 00 00    	je     80101f2e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101dca:	e8 41 1c 00 00       	call   80103a10 <myproc>
  acquire(&icache.lock);
80101dcf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101dd2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101dd5:	68 60 09 11 80       	push   $0x80110960
80101dda:	e8 c1 2c 00 00       	call   80104aa0 <acquire>
  ip->ref++;
80101ddf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101de3:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101dea:	e8 51 2c 00 00       	call   80104a40 <release>
80101def:	83 c4 10             	add    $0x10,%esp
80101df2:	eb 07                	jmp    80101dfb <namex+0x4b>
80101df4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101df8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101dfb:	0f b6 03             	movzbl (%ebx),%eax
80101dfe:	3c 2f                	cmp    $0x2f,%al
80101e00:	74 f6                	je     80101df8 <namex+0x48>
  if(*path == 0)
80101e02:	84 c0                	test   %al,%al
80101e04:	0f 84 06 01 00 00    	je     80101f10 <namex+0x160>
  while(*path != '/' && *path != 0)
80101e0a:	0f b6 03             	movzbl (%ebx),%eax
80101e0d:	84 c0                	test   %al,%al
80101e0f:	0f 84 10 01 00 00    	je     80101f25 <namex+0x175>
80101e15:	89 df                	mov    %ebx,%edi
80101e17:	3c 2f                	cmp    $0x2f,%al
80101e19:	0f 84 06 01 00 00    	je     80101f25 <namex+0x175>
80101e1f:	90                   	nop
80101e20:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e24:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e27:	3c 2f                	cmp    $0x2f,%al
80101e29:	74 04                	je     80101e2f <namex+0x7f>
80101e2b:	84 c0                	test   %al,%al
80101e2d:	75 f1                	jne    80101e20 <namex+0x70>
  len = path - s;
80101e2f:	89 f8                	mov    %edi,%eax
80101e31:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e33:	83 f8 0d             	cmp    $0xd,%eax
80101e36:	0f 8e ac 00 00 00    	jle    80101ee8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e3c:	83 ec 04             	sub    $0x4,%esp
80101e3f:	6a 0e                	push   $0xe
80101e41:	53                   	push   %ebx
    path++;
80101e42:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101e44:	ff 75 e4             	push   -0x1c(%ebp)
80101e47:	e8 b4 2d 00 00       	call   80104c00 <memmove>
80101e4c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e4f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e52:	75 0c                	jne    80101e60 <namex+0xb0>
80101e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e58:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e5b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e5e:	74 f8                	je     80101e58 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e60:	83 ec 0c             	sub    $0xc,%esp
80101e63:	56                   	push   %esi
80101e64:	e8 37 f9 ff ff       	call   801017a0 <ilock>
    if(ip->type != T_DIR){
80101e69:	83 c4 10             	add    $0x10,%esp
80101e6c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e71:	0f 85 cd 00 00 00    	jne    80101f44 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e77:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e7a:	85 c0                	test   %eax,%eax
80101e7c:	74 09                	je     80101e87 <namex+0xd7>
80101e7e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e81:	0f 84 22 01 00 00    	je     80101fa9 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e87:	83 ec 04             	sub    $0x4,%esp
80101e8a:	6a 00                	push   $0x0
80101e8c:	ff 75 e4             	push   -0x1c(%ebp)
80101e8f:	56                   	push   %esi
80101e90:	e8 6b fe ff ff       	call   80101d00 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e95:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101e98:	83 c4 10             	add    $0x10,%esp
80101e9b:	89 c7                	mov    %eax,%edi
80101e9d:	85 c0                	test   %eax,%eax
80101e9f:	0f 84 e1 00 00 00    	je     80101f86 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101ea5:	83 ec 0c             	sub    $0xc,%esp
80101ea8:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101eab:	52                   	push   %edx
80101eac:	e8 cf 29 00 00       	call   80104880 <holdingsleep>
80101eb1:	83 c4 10             	add    $0x10,%esp
80101eb4:	85 c0                	test   %eax,%eax
80101eb6:	0f 84 30 01 00 00    	je     80101fec <namex+0x23c>
80101ebc:	8b 56 08             	mov    0x8(%esi),%edx
80101ebf:	85 d2                	test   %edx,%edx
80101ec1:	0f 8e 25 01 00 00    	jle    80101fec <namex+0x23c>
  releasesleep(&ip->lock);
80101ec7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101eca:	83 ec 0c             	sub    $0xc,%esp
80101ecd:	52                   	push   %edx
80101ece:	e8 6d 29 00 00       	call   80104840 <releasesleep>
  iput(ip);
80101ed3:	89 34 24             	mov    %esi,(%esp)
80101ed6:	89 fe                	mov    %edi,%esi
80101ed8:	e8 f3 f9 ff ff       	call   801018d0 <iput>
80101edd:	83 c4 10             	add    $0x10,%esp
80101ee0:	e9 16 ff ff ff       	jmp    80101dfb <namex+0x4b>
80101ee5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ee8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101eeb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101eee:	83 ec 04             	sub    $0x4,%esp
80101ef1:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101ef4:	50                   	push   %eax
80101ef5:	53                   	push   %ebx
    name[len] = 0;
80101ef6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101ef8:	ff 75 e4             	push   -0x1c(%ebp)
80101efb:	e8 00 2d 00 00       	call   80104c00 <memmove>
    name[len] = 0;
80101f00:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101f03:	83 c4 10             	add    $0x10,%esp
80101f06:	c6 02 00             	movb   $0x0,(%edx)
80101f09:	e9 41 ff ff ff       	jmp    80101e4f <namex+0x9f>
80101f0e:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101f10:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f13:	85 c0                	test   %eax,%eax
80101f15:	0f 85 be 00 00 00    	jne    80101fd9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f1e:	89 f0                	mov    %esi,%eax
80101f20:	5b                   	pop    %ebx
80101f21:	5e                   	pop    %esi
80101f22:	5f                   	pop    %edi
80101f23:	5d                   	pop    %ebp
80101f24:	c3                   	ret    
  while(*path != '/' && *path != 0)
80101f25:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f28:	89 df                	mov    %ebx,%edi
80101f2a:	31 c0                	xor    %eax,%eax
80101f2c:	eb c0                	jmp    80101eee <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
80101f2e:	ba 01 00 00 00       	mov    $0x1,%edx
80101f33:	b8 01 00 00 00       	mov    $0x1,%eax
80101f38:	e8 33 f4 ff ff       	call   80101370 <iget>
80101f3d:	89 c6                	mov    %eax,%esi
80101f3f:	e9 b7 fe ff ff       	jmp    80101dfb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f44:	83 ec 0c             	sub    $0xc,%esp
80101f47:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f4a:	53                   	push   %ebx
80101f4b:	e8 30 29 00 00       	call   80104880 <holdingsleep>
80101f50:	83 c4 10             	add    $0x10,%esp
80101f53:	85 c0                	test   %eax,%eax
80101f55:	0f 84 91 00 00 00    	je     80101fec <namex+0x23c>
80101f5b:	8b 46 08             	mov    0x8(%esi),%eax
80101f5e:	85 c0                	test   %eax,%eax
80101f60:	0f 8e 86 00 00 00    	jle    80101fec <namex+0x23c>
  releasesleep(&ip->lock);
80101f66:	83 ec 0c             	sub    $0xc,%esp
80101f69:	53                   	push   %ebx
80101f6a:	e8 d1 28 00 00       	call   80104840 <releasesleep>
  iput(ip);
80101f6f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f72:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f74:	e8 57 f9 ff ff       	call   801018d0 <iput>
      return 0;
80101f79:	83 c4 10             	add    $0x10,%esp
}
80101f7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f7f:	89 f0                	mov    %esi,%eax
80101f81:	5b                   	pop    %ebx
80101f82:	5e                   	pop    %esi
80101f83:	5f                   	pop    %edi
80101f84:	5d                   	pop    %ebp
80101f85:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f86:	83 ec 0c             	sub    $0xc,%esp
80101f89:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101f8c:	52                   	push   %edx
80101f8d:	e8 ee 28 00 00       	call   80104880 <holdingsleep>
80101f92:	83 c4 10             	add    $0x10,%esp
80101f95:	85 c0                	test   %eax,%eax
80101f97:	74 53                	je     80101fec <namex+0x23c>
80101f99:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f9c:	85 c9                	test   %ecx,%ecx
80101f9e:	7e 4c                	jle    80101fec <namex+0x23c>
  releasesleep(&ip->lock);
80101fa0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101fa3:	83 ec 0c             	sub    $0xc,%esp
80101fa6:	52                   	push   %edx
80101fa7:	eb c1                	jmp    80101f6a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101fa9:	83 ec 0c             	sub    $0xc,%esp
80101fac:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101faf:	53                   	push   %ebx
80101fb0:	e8 cb 28 00 00       	call   80104880 <holdingsleep>
80101fb5:	83 c4 10             	add    $0x10,%esp
80101fb8:	85 c0                	test   %eax,%eax
80101fba:	74 30                	je     80101fec <namex+0x23c>
80101fbc:	8b 7e 08             	mov    0x8(%esi),%edi
80101fbf:	85 ff                	test   %edi,%edi
80101fc1:	7e 29                	jle    80101fec <namex+0x23c>
  releasesleep(&ip->lock);
80101fc3:	83 ec 0c             	sub    $0xc,%esp
80101fc6:	53                   	push   %ebx
80101fc7:	e8 74 28 00 00       	call   80104840 <releasesleep>
}
80101fcc:	83 c4 10             	add    $0x10,%esp
}
80101fcf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fd2:	89 f0                	mov    %esi,%eax
80101fd4:	5b                   	pop    %ebx
80101fd5:	5e                   	pop    %esi
80101fd6:	5f                   	pop    %edi
80101fd7:	5d                   	pop    %ebp
80101fd8:	c3                   	ret    
    iput(ip);
80101fd9:	83 ec 0c             	sub    $0xc,%esp
80101fdc:	56                   	push   %esi
    return 0;
80101fdd:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fdf:	e8 ec f8 ff ff       	call   801018d0 <iput>
    return 0;
80101fe4:	83 c4 10             	add    $0x10,%esp
80101fe7:	e9 2f ff ff ff       	jmp    80101f1b <namex+0x16b>
    panic("iunlock");
80101fec:	83 ec 0c             	sub    $0xc,%esp
80101fef:	68 df 79 10 80       	push   $0x801079df
80101ff4:	e8 87 e3 ff ff       	call   80100380 <panic>
80101ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102000 <dirlink>:
{
80102000:	55                   	push   %ebp
80102001:	89 e5                	mov    %esp,%ebp
80102003:	57                   	push   %edi
80102004:	56                   	push   %esi
80102005:	53                   	push   %ebx
80102006:	83 ec 20             	sub    $0x20,%esp
80102009:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010200c:	6a 00                	push   $0x0
8010200e:	ff 75 0c             	push   0xc(%ebp)
80102011:	53                   	push   %ebx
80102012:	e8 e9 fc ff ff       	call   80101d00 <dirlookup>
80102017:	83 c4 10             	add    $0x10,%esp
8010201a:	85 c0                	test   %eax,%eax
8010201c:	75 67                	jne    80102085 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010201e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102021:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102024:	85 ff                	test   %edi,%edi
80102026:	74 29                	je     80102051 <dirlink+0x51>
80102028:	31 ff                	xor    %edi,%edi
8010202a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010202d:	eb 09                	jmp    80102038 <dirlink+0x38>
8010202f:	90                   	nop
80102030:	83 c7 10             	add    $0x10,%edi
80102033:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102036:	73 19                	jae    80102051 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102038:	6a 10                	push   $0x10
8010203a:	57                   	push   %edi
8010203b:	56                   	push   %esi
8010203c:	53                   	push   %ebx
8010203d:	e8 6e fa ff ff       	call   80101ab0 <readi>
80102042:	83 c4 10             	add    $0x10,%esp
80102045:	83 f8 10             	cmp    $0x10,%eax
80102048:	75 4e                	jne    80102098 <dirlink+0x98>
    if(de.inum == 0)
8010204a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010204f:	75 df                	jne    80102030 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102051:	83 ec 04             	sub    $0x4,%esp
80102054:	8d 45 da             	lea    -0x26(%ebp),%eax
80102057:	6a 0e                	push   $0xe
80102059:	ff 75 0c             	push   0xc(%ebp)
8010205c:	50                   	push   %eax
8010205d:	e8 5e 2c 00 00       	call   80104cc0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102062:	6a 10                	push   $0x10
  de.inum = inum;
80102064:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102067:	57                   	push   %edi
80102068:	56                   	push   %esi
80102069:	53                   	push   %ebx
  de.inum = inum;
8010206a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010206e:	e8 3d fb ff ff       	call   80101bb0 <writei>
80102073:	83 c4 20             	add    $0x20,%esp
80102076:	83 f8 10             	cmp    $0x10,%eax
80102079:	75 2a                	jne    801020a5 <dirlink+0xa5>
  return 0;
8010207b:	31 c0                	xor    %eax,%eax
}
8010207d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102080:	5b                   	pop    %ebx
80102081:	5e                   	pop    %esi
80102082:	5f                   	pop    %edi
80102083:	5d                   	pop    %ebp
80102084:	c3                   	ret    
    iput(ip);
80102085:	83 ec 0c             	sub    $0xc,%esp
80102088:	50                   	push   %eax
80102089:	e8 42 f8 ff ff       	call   801018d0 <iput>
    return -1;
8010208e:	83 c4 10             	add    $0x10,%esp
80102091:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102096:	eb e5                	jmp    8010207d <dirlink+0x7d>
      panic("dirlink read");
80102098:	83 ec 0c             	sub    $0xc,%esp
8010209b:	68 08 7a 10 80       	push   $0x80107a08
801020a0:	e8 db e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
801020a5:	83 ec 0c             	sub    $0xc,%esp
801020a8:	68 ea 7f 10 80       	push   $0x80107fea
801020ad:	e8 ce e2 ff ff       	call   80100380 <panic>
801020b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020c0 <namei>:

struct inode*
namei(char *path)
{
801020c0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020c1:	31 d2                	xor    %edx,%edx
{
801020c3:	89 e5                	mov    %esp,%ebp
801020c5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020c8:	8b 45 08             	mov    0x8(%ebp),%eax
801020cb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020ce:	e8 dd fc ff ff       	call   80101db0 <namex>
}
801020d3:	c9                   	leave  
801020d4:	c3                   	ret    
801020d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020e0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020e0:	55                   	push   %ebp
  return namex(path, 1, name);
801020e1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020e6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020eb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020ee:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020ef:	e9 bc fc ff ff       	jmp    80101db0 <namex>
801020f4:	66 90                	xchg   %ax,%ax
801020f6:	66 90                	xchg   %ax,%ax
801020f8:	66 90                	xchg   %ax,%ax
801020fa:	66 90                	xchg   %ax,%ax
801020fc:	66 90                	xchg   %ax,%ax
801020fe:	66 90                	xchg   %ax,%ax

80102100 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102100:	55                   	push   %ebp
80102101:	89 e5                	mov    %esp,%ebp
80102103:	57                   	push   %edi
80102104:	56                   	push   %esi
80102105:	53                   	push   %ebx
80102106:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102109:	85 c0                	test   %eax,%eax
8010210b:	0f 84 b4 00 00 00    	je     801021c5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102111:	8b 70 08             	mov    0x8(%eax),%esi
80102114:	89 c3                	mov    %eax,%ebx
80102116:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010211c:	0f 87 96 00 00 00    	ja     801021b8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102122:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102127:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010212e:	66 90                	xchg   %ax,%ax
80102130:	89 ca                	mov    %ecx,%edx
80102132:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102133:	83 e0 c0             	and    $0xffffffc0,%eax
80102136:	3c 40                	cmp    $0x40,%al
80102138:	75 f6                	jne    80102130 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010213a:	31 ff                	xor    %edi,%edi
8010213c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102141:	89 f8                	mov    %edi,%eax
80102143:	ee                   	out    %al,(%dx)
80102144:	b8 01 00 00 00       	mov    $0x1,%eax
80102149:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010214e:	ee                   	out    %al,(%dx)
8010214f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102154:	89 f0                	mov    %esi,%eax
80102156:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102157:	89 f0                	mov    %esi,%eax
80102159:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010215e:	c1 f8 08             	sar    $0x8,%eax
80102161:	ee                   	out    %al,(%dx)
80102162:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102167:	89 f8                	mov    %edi,%eax
80102169:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010216a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010216e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102173:	c1 e0 04             	shl    $0x4,%eax
80102176:	83 e0 10             	and    $0x10,%eax
80102179:	83 c8 e0             	or     $0xffffffe0,%eax
8010217c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010217d:	f6 03 04             	testb  $0x4,(%ebx)
80102180:	75 16                	jne    80102198 <idestart+0x98>
80102182:	b8 20 00 00 00       	mov    $0x20,%eax
80102187:	89 ca                	mov    %ecx,%edx
80102189:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010218a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010218d:	5b                   	pop    %ebx
8010218e:	5e                   	pop    %esi
8010218f:	5f                   	pop    %edi
80102190:	5d                   	pop    %ebp
80102191:	c3                   	ret    
80102192:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102198:	b8 30 00 00 00       	mov    $0x30,%eax
8010219d:	89 ca                	mov    %ecx,%edx
8010219f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801021a0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801021a5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801021a8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801021ad:	fc                   	cld    
801021ae:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801021b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021b3:	5b                   	pop    %ebx
801021b4:	5e                   	pop    %esi
801021b5:	5f                   	pop    %edi
801021b6:	5d                   	pop    %ebp
801021b7:	c3                   	ret    
    panic("incorrect blockno");
801021b8:	83 ec 0c             	sub    $0xc,%esp
801021bb:	68 74 7a 10 80       	push   $0x80107a74
801021c0:	e8 bb e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021c5:	83 ec 0c             	sub    $0xc,%esp
801021c8:	68 6b 7a 10 80       	push   $0x80107a6b
801021cd:	e8 ae e1 ff ff       	call   80100380 <panic>
801021d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021e0 <ideinit>:
{
801021e0:	55                   	push   %ebp
801021e1:	89 e5                	mov    %esp,%ebp
801021e3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021e6:	68 86 7a 10 80       	push   $0x80107a86
801021eb:	68 00 26 11 80       	push   $0x80112600
801021f0:	e8 db 26 00 00       	call   801048d0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021f5:	58                   	pop    %eax
801021f6:	a1 84 27 11 80       	mov    0x80112784,%eax
801021fb:	5a                   	pop    %edx
801021fc:	83 e8 01             	sub    $0x1,%eax
801021ff:	50                   	push   %eax
80102200:	6a 0e                	push   $0xe
80102202:	e8 99 02 00 00       	call   801024a0 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102207:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010220a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010220f:	90                   	nop
80102210:	ec                   	in     (%dx),%al
80102211:	83 e0 c0             	and    $0xffffffc0,%eax
80102214:	3c 40                	cmp    $0x40,%al
80102216:	75 f8                	jne    80102210 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102218:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010221d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102222:	ee                   	out    %al,(%dx)
80102223:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102228:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010222d:	eb 06                	jmp    80102235 <ideinit+0x55>
8010222f:	90                   	nop
  for(i=0; i<1000; i++){
80102230:	83 e9 01             	sub    $0x1,%ecx
80102233:	74 0f                	je     80102244 <ideinit+0x64>
80102235:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102236:	84 c0                	test   %al,%al
80102238:	74 f6                	je     80102230 <ideinit+0x50>
      havedisk1 = 1;
8010223a:	c7 05 e0 25 11 80 01 	movl   $0x1,0x801125e0
80102241:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102244:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102249:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010224e:	ee                   	out    %al,(%dx)
}
8010224f:	c9                   	leave  
80102250:	c3                   	ret    
80102251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102258:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010225f:	90                   	nop

80102260 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102260:	55                   	push   %ebp
80102261:	89 e5                	mov    %esp,%ebp
80102263:	57                   	push   %edi
80102264:	56                   	push   %esi
80102265:	53                   	push   %ebx
80102266:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102269:	68 00 26 11 80       	push   $0x80112600
8010226e:	e8 2d 28 00 00       	call   80104aa0 <acquire>

  if((b = idequeue) == 0){
80102273:	8b 1d e4 25 11 80    	mov    0x801125e4,%ebx
80102279:	83 c4 10             	add    $0x10,%esp
8010227c:	85 db                	test   %ebx,%ebx
8010227e:	74 63                	je     801022e3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102280:	8b 43 58             	mov    0x58(%ebx),%eax
80102283:	a3 e4 25 11 80       	mov    %eax,0x801125e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102288:	8b 33                	mov    (%ebx),%esi
8010228a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102290:	75 2f                	jne    801022c1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102292:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102297:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010229e:	66 90                	xchg   %ax,%ax
801022a0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022a1:	89 c1                	mov    %eax,%ecx
801022a3:	83 e1 c0             	and    $0xffffffc0,%ecx
801022a6:	80 f9 40             	cmp    $0x40,%cl
801022a9:	75 f5                	jne    801022a0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801022ab:	a8 21                	test   $0x21,%al
801022ad:	75 12                	jne    801022c1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
801022af:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801022b2:	b9 80 00 00 00       	mov    $0x80,%ecx
801022b7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801022bc:	fc                   	cld    
801022bd:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801022bf:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801022c1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801022c4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801022c7:	83 ce 02             	or     $0x2,%esi
801022ca:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801022cc:	53                   	push   %ebx
801022cd:	e8 ee 1e 00 00       	call   801041c0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022d2:	a1 e4 25 11 80       	mov    0x801125e4,%eax
801022d7:	83 c4 10             	add    $0x10,%esp
801022da:	85 c0                	test   %eax,%eax
801022dc:	74 05                	je     801022e3 <ideintr+0x83>
    idestart(idequeue);
801022de:	e8 1d fe ff ff       	call   80102100 <idestart>
    release(&idelock);
801022e3:	83 ec 0c             	sub    $0xc,%esp
801022e6:	68 00 26 11 80       	push   $0x80112600
801022eb:	e8 50 27 00 00       	call   80104a40 <release>

  release(&idelock);
}
801022f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022f3:	5b                   	pop    %ebx
801022f4:	5e                   	pop    %esi
801022f5:	5f                   	pop    %edi
801022f6:	5d                   	pop    %ebp
801022f7:	c3                   	ret    
801022f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022ff:	90                   	nop

80102300 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102300:	55                   	push   %ebp
80102301:	89 e5                	mov    %esp,%ebp
80102303:	53                   	push   %ebx
80102304:	83 ec 10             	sub    $0x10,%esp
80102307:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010230a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010230d:	50                   	push   %eax
8010230e:	e8 6d 25 00 00       	call   80104880 <holdingsleep>
80102313:	83 c4 10             	add    $0x10,%esp
80102316:	85 c0                	test   %eax,%eax
80102318:	0f 84 c3 00 00 00    	je     801023e1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010231e:	8b 03                	mov    (%ebx),%eax
80102320:	83 e0 06             	and    $0x6,%eax
80102323:	83 f8 02             	cmp    $0x2,%eax
80102326:	0f 84 a8 00 00 00    	je     801023d4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010232c:	8b 53 04             	mov    0x4(%ebx),%edx
8010232f:	85 d2                	test   %edx,%edx
80102331:	74 0d                	je     80102340 <iderw+0x40>
80102333:	a1 e0 25 11 80       	mov    0x801125e0,%eax
80102338:	85 c0                	test   %eax,%eax
8010233a:	0f 84 87 00 00 00    	je     801023c7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102340:	83 ec 0c             	sub    $0xc,%esp
80102343:	68 00 26 11 80       	push   $0x80112600
80102348:	e8 53 27 00 00       	call   80104aa0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010234d:	a1 e4 25 11 80       	mov    0x801125e4,%eax
  b->qnext = 0;
80102352:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102359:	83 c4 10             	add    $0x10,%esp
8010235c:	85 c0                	test   %eax,%eax
8010235e:	74 60                	je     801023c0 <iderw+0xc0>
80102360:	89 c2                	mov    %eax,%edx
80102362:	8b 40 58             	mov    0x58(%eax),%eax
80102365:	85 c0                	test   %eax,%eax
80102367:	75 f7                	jne    80102360 <iderw+0x60>
80102369:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010236c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010236e:	39 1d e4 25 11 80    	cmp    %ebx,0x801125e4
80102374:	74 3a                	je     801023b0 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102376:	8b 03                	mov    (%ebx),%eax
80102378:	83 e0 06             	and    $0x6,%eax
8010237b:	83 f8 02             	cmp    $0x2,%eax
8010237e:	74 1b                	je     8010239b <iderw+0x9b>
    sleep(b, &idelock);
80102380:	83 ec 08             	sub    $0x8,%esp
80102383:	68 00 26 11 80       	push   $0x80112600
80102388:	53                   	push   %ebx
80102389:	e8 72 1d 00 00       	call   80104100 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010238e:	8b 03                	mov    (%ebx),%eax
80102390:	83 c4 10             	add    $0x10,%esp
80102393:	83 e0 06             	and    $0x6,%eax
80102396:	83 f8 02             	cmp    $0x2,%eax
80102399:	75 e5                	jne    80102380 <iderw+0x80>
  }


  release(&idelock);
8010239b:	c7 45 08 00 26 11 80 	movl   $0x80112600,0x8(%ebp)
}
801023a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023a5:	c9                   	leave  
  release(&idelock);
801023a6:	e9 95 26 00 00       	jmp    80104a40 <release>
801023ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023af:	90                   	nop
    idestart(b);
801023b0:	89 d8                	mov    %ebx,%eax
801023b2:	e8 49 fd ff ff       	call   80102100 <idestart>
801023b7:	eb bd                	jmp    80102376 <iderw+0x76>
801023b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023c0:	ba e4 25 11 80       	mov    $0x801125e4,%edx
801023c5:	eb a5                	jmp    8010236c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801023c7:	83 ec 0c             	sub    $0xc,%esp
801023ca:	68 b5 7a 10 80       	push   $0x80107ab5
801023cf:	e8 ac df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023d4:	83 ec 0c             	sub    $0xc,%esp
801023d7:	68 a0 7a 10 80       	push   $0x80107aa0
801023dc:	e8 9f df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023e1:	83 ec 0c             	sub    $0xc,%esp
801023e4:	68 8a 7a 10 80       	push   $0x80107a8a
801023e9:	e8 92 df ff ff       	call   80100380 <panic>
801023ee:	66 90                	xchg   %ax,%ax

801023f0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023f0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023f1:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801023f8:	00 c0 fe 
{
801023fb:	89 e5                	mov    %esp,%ebp
801023fd:	56                   	push   %esi
801023fe:	53                   	push   %ebx
  ioapic->reg = reg;
801023ff:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102406:	00 00 00 
  return ioapic->data;
80102409:	8b 15 34 26 11 80    	mov    0x80112634,%edx
8010240f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102412:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102418:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010241e:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102425:	c1 ee 10             	shr    $0x10,%esi
80102428:	89 f0                	mov    %esi,%eax
8010242a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010242d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102430:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102433:	39 c2                	cmp    %eax,%edx
80102435:	74 16                	je     8010244d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102437:	83 ec 0c             	sub    $0xc,%esp
8010243a:	68 d4 7a 10 80       	push   $0x80107ad4
8010243f:	e8 5c e2 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102444:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010244a:	83 c4 10             	add    $0x10,%esp
8010244d:	83 c6 21             	add    $0x21,%esi
{
80102450:	ba 10 00 00 00       	mov    $0x10,%edx
80102455:	b8 20 00 00 00       	mov    $0x20,%eax
8010245a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102460:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102462:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102464:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  for(i = 0; i <= maxintr; i++){
8010246a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010246d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102473:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102476:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102479:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010247c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010247e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102484:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010248b:	39 f0                	cmp    %esi,%eax
8010248d:	75 d1                	jne    80102460 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010248f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102492:	5b                   	pop    %ebx
80102493:	5e                   	pop    %esi
80102494:	5d                   	pop    %ebp
80102495:	c3                   	ret    
80102496:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010249d:	8d 76 00             	lea    0x0(%esi),%esi

801024a0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801024a0:	55                   	push   %ebp
  ioapic->reg = reg;
801024a1:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
801024a7:	89 e5                	mov    %esp,%ebp
801024a9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801024ac:	8d 50 20             	lea    0x20(%eax),%edx
801024af:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801024b3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024b5:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024bb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801024be:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024c4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024c6:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024cb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024ce:	89 50 10             	mov    %edx,0x10(%eax)
}
801024d1:	5d                   	pop    %ebp
801024d2:	c3                   	ret    
801024d3:	66 90                	xchg   %ax,%ax
801024d5:	66 90                	xchg   %ax,%ax
801024d7:	66 90                	xchg   %ax,%ax
801024d9:	66 90                	xchg   %ax,%ax
801024db:	66 90                	xchg   %ax,%ax
801024dd:	66 90                	xchg   %ax,%ax
801024df:	90                   	nop

801024e0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024e0:	55                   	push   %ebp
801024e1:	89 e5                	mov    %esp,%ebp
801024e3:	53                   	push   %ebx
801024e4:	83 ec 04             	sub    $0x4,%esp
801024e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024ea:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024f0:	75 76                	jne    80102568 <kfree+0x88>
801024f2:	81 fb d0 68 11 80    	cmp    $0x801168d0,%ebx
801024f8:	72 6e                	jb     80102568 <kfree+0x88>
801024fa:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102500:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102505:	77 61                	ja     80102568 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102507:	83 ec 04             	sub    $0x4,%esp
8010250a:	68 00 10 00 00       	push   $0x1000
8010250f:	6a 01                	push   $0x1
80102511:	53                   	push   %ebx
80102512:	e8 49 26 00 00       	call   80104b60 <memset>

  if(kmem.use_lock)
80102517:	8b 15 74 26 11 80    	mov    0x80112674,%edx
8010251d:	83 c4 10             	add    $0x10,%esp
80102520:	85 d2                	test   %edx,%edx
80102522:	75 1c                	jne    80102540 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102524:	a1 78 26 11 80       	mov    0x80112678,%eax
80102529:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010252b:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102530:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102536:	85 c0                	test   %eax,%eax
80102538:	75 1e                	jne    80102558 <kfree+0x78>
    release(&kmem.lock);
}
8010253a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010253d:	c9                   	leave  
8010253e:	c3                   	ret    
8010253f:	90                   	nop
    acquire(&kmem.lock);
80102540:	83 ec 0c             	sub    $0xc,%esp
80102543:	68 40 26 11 80       	push   $0x80112640
80102548:	e8 53 25 00 00       	call   80104aa0 <acquire>
8010254d:	83 c4 10             	add    $0x10,%esp
80102550:	eb d2                	jmp    80102524 <kfree+0x44>
80102552:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102558:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010255f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102562:	c9                   	leave  
    release(&kmem.lock);
80102563:	e9 d8 24 00 00       	jmp    80104a40 <release>
    panic("kfree");
80102568:	83 ec 0c             	sub    $0xc,%esp
8010256b:	68 06 7b 10 80       	push   $0x80107b06
80102570:	e8 0b de ff ff       	call   80100380 <panic>
80102575:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010257c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102580 <freerange>:
{
80102580:	55                   	push   %ebp
80102581:	89 e5                	mov    %esp,%ebp
80102583:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102584:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102587:	8b 75 0c             	mov    0xc(%ebp),%esi
8010258a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010258b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102591:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102597:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010259d:	39 de                	cmp    %ebx,%esi
8010259f:	72 23                	jb     801025c4 <freerange+0x44>
801025a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025a8:	83 ec 0c             	sub    $0xc,%esp
801025ab:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025b7:	50                   	push   %eax
801025b8:	e8 23 ff ff ff       	call   801024e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025bd:	83 c4 10             	add    $0x10,%esp
801025c0:	39 f3                	cmp    %esi,%ebx
801025c2:	76 e4                	jbe    801025a8 <freerange+0x28>
}
801025c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025c7:	5b                   	pop    %ebx
801025c8:	5e                   	pop    %esi
801025c9:	5d                   	pop    %ebp
801025ca:	c3                   	ret    
801025cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025cf:	90                   	nop

801025d0 <kinit2>:
{
801025d0:	55                   	push   %ebp
801025d1:	89 e5                	mov    %esp,%ebp
801025d3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025d4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025d7:	8b 75 0c             	mov    0xc(%ebp),%esi
801025da:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025db:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025e1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025e7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025ed:	39 de                	cmp    %ebx,%esi
801025ef:	72 23                	jb     80102614 <kinit2+0x44>
801025f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025f8:	83 ec 0c             	sub    $0xc,%esp
801025fb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102601:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102607:	50                   	push   %eax
80102608:	e8 d3 fe ff ff       	call   801024e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010260d:	83 c4 10             	add    $0x10,%esp
80102610:	39 de                	cmp    %ebx,%esi
80102612:	73 e4                	jae    801025f8 <kinit2+0x28>
  kmem.use_lock = 1;
80102614:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010261b:	00 00 00 
}
8010261e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102621:	5b                   	pop    %ebx
80102622:	5e                   	pop    %esi
80102623:	5d                   	pop    %ebp
80102624:	c3                   	ret    
80102625:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010262c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102630 <kinit1>:
{
80102630:	55                   	push   %ebp
80102631:	89 e5                	mov    %esp,%ebp
80102633:	56                   	push   %esi
80102634:	53                   	push   %ebx
80102635:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102638:	83 ec 08             	sub    $0x8,%esp
8010263b:	68 0c 7b 10 80       	push   $0x80107b0c
80102640:	68 40 26 11 80       	push   $0x80112640
80102645:	e8 86 22 00 00       	call   801048d0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010264a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010264d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102650:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102657:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010265a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102660:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102666:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010266c:	39 de                	cmp    %ebx,%esi
8010266e:	72 1c                	jb     8010268c <kinit1+0x5c>
    kfree(p);
80102670:	83 ec 0c             	sub    $0xc,%esp
80102673:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102679:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010267f:	50                   	push   %eax
80102680:	e8 5b fe ff ff       	call   801024e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102685:	83 c4 10             	add    $0x10,%esp
80102688:	39 de                	cmp    %ebx,%esi
8010268a:	73 e4                	jae    80102670 <kinit1+0x40>
}
8010268c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010268f:	5b                   	pop    %ebx
80102690:	5e                   	pop    %esi
80102691:	5d                   	pop    %ebp
80102692:	c3                   	ret    
80102693:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010269a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801026a0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801026a0:	a1 74 26 11 80       	mov    0x80112674,%eax
801026a5:	85 c0                	test   %eax,%eax
801026a7:	75 1f                	jne    801026c8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801026a9:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
801026ae:	85 c0                	test   %eax,%eax
801026b0:	74 0e                	je     801026c0 <kalloc+0x20>
    kmem.freelist = r->next;
801026b2:	8b 10                	mov    (%eax),%edx
801026b4:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
801026ba:	c3                   	ret    
801026bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026bf:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
801026c0:	c3                   	ret    
801026c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801026c8:	55                   	push   %ebp
801026c9:	89 e5                	mov    %esp,%ebp
801026cb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801026ce:	68 40 26 11 80       	push   $0x80112640
801026d3:	e8 c8 23 00 00       	call   80104aa0 <acquire>
  r = kmem.freelist;
801026d8:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(kmem.use_lock)
801026dd:	8b 15 74 26 11 80    	mov    0x80112674,%edx
  if(r)
801026e3:	83 c4 10             	add    $0x10,%esp
801026e6:	85 c0                	test   %eax,%eax
801026e8:	74 08                	je     801026f2 <kalloc+0x52>
    kmem.freelist = r->next;
801026ea:	8b 08                	mov    (%eax),%ecx
801026ec:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
801026f2:	85 d2                	test   %edx,%edx
801026f4:	74 16                	je     8010270c <kalloc+0x6c>
    release(&kmem.lock);
801026f6:	83 ec 0c             	sub    $0xc,%esp
801026f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026fc:	68 40 26 11 80       	push   $0x80112640
80102701:	e8 3a 23 00 00       	call   80104a40 <release>
  return (char*)r;
80102706:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102709:	83 c4 10             	add    $0x10,%esp
}
8010270c:	c9                   	leave  
8010270d:	c3                   	ret    
8010270e:	66 90                	xchg   %ax,%ax

80102710 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102710:	ba 64 00 00 00       	mov    $0x64,%edx
80102715:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102716:	a8 01                	test   $0x1,%al
80102718:	0f 84 c2 00 00 00    	je     801027e0 <kbdgetc+0xd0>
{
8010271e:	55                   	push   %ebp
8010271f:	ba 60 00 00 00       	mov    $0x60,%edx
80102724:	89 e5                	mov    %esp,%ebp
80102726:	53                   	push   %ebx
80102727:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102728:	8b 1d 7c 26 11 80    	mov    0x8011267c,%ebx
  data = inb(KBDATAP);
8010272e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102731:	3c e0                	cmp    $0xe0,%al
80102733:	74 5b                	je     80102790 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102735:	89 da                	mov    %ebx,%edx
80102737:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010273a:	84 c0                	test   %al,%al
8010273c:	78 62                	js     801027a0 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010273e:	85 d2                	test   %edx,%edx
80102740:	74 09                	je     8010274b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102742:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102745:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102748:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010274b:	0f b6 91 40 7c 10 80 	movzbl -0x7fef83c0(%ecx),%edx
  shift ^= togglecode[data];
80102752:	0f b6 81 40 7b 10 80 	movzbl -0x7fef84c0(%ecx),%eax
  shift |= shiftcode[data];
80102759:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010275b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010275d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010275f:	89 15 7c 26 11 80    	mov    %edx,0x8011267c
  c = charcode[shift & (CTL | SHIFT)][data];
80102765:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102768:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010276b:	8b 04 85 20 7b 10 80 	mov    -0x7fef84e0(,%eax,4),%eax
80102772:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102776:	74 0b                	je     80102783 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102778:	8d 50 9f             	lea    -0x61(%eax),%edx
8010277b:	83 fa 19             	cmp    $0x19,%edx
8010277e:	77 48                	ja     801027c8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102780:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102783:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102786:	c9                   	leave  
80102787:	c3                   	ret    
80102788:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010278f:	90                   	nop
    shift |= E0ESC;
80102790:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102793:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102795:	89 1d 7c 26 11 80    	mov    %ebx,0x8011267c
}
8010279b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010279e:	c9                   	leave  
8010279f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
801027a0:	83 e0 7f             	and    $0x7f,%eax
801027a3:	85 d2                	test   %edx,%edx
801027a5:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
801027a8:	0f b6 81 40 7c 10 80 	movzbl -0x7fef83c0(%ecx),%eax
801027af:	83 c8 40             	or     $0x40,%eax
801027b2:	0f b6 c0             	movzbl %al,%eax
801027b5:	f7 d0                	not    %eax
801027b7:	21 d8                	and    %ebx,%eax
}
801027b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
801027bc:	a3 7c 26 11 80       	mov    %eax,0x8011267c
    return 0;
801027c1:	31 c0                	xor    %eax,%eax
}
801027c3:	c9                   	leave  
801027c4:	c3                   	ret    
801027c5:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801027c8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801027cb:	8d 50 20             	lea    0x20(%eax),%edx
}
801027ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027d1:	c9                   	leave  
      c += 'a' - 'A';
801027d2:	83 f9 1a             	cmp    $0x1a,%ecx
801027d5:	0f 42 c2             	cmovb  %edx,%eax
}
801027d8:	c3                   	ret    
801027d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801027e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801027e5:	c3                   	ret    
801027e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027ed:	8d 76 00             	lea    0x0(%esi),%esi

801027f0 <kbdintr>:

void
kbdintr(void)
{
801027f0:	55                   	push   %ebp
801027f1:	89 e5                	mov    %esp,%ebp
801027f3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801027f6:	68 10 27 10 80       	push   $0x80102710
801027fb:	e8 80 e0 ff ff       	call   80100880 <consoleintr>
}
80102800:	83 c4 10             	add    $0x10,%esp
80102803:	c9                   	leave  
80102804:	c3                   	ret    
80102805:	66 90                	xchg   %ax,%ax
80102807:	66 90                	xchg   %ax,%ax
80102809:	66 90                	xchg   %ax,%ax
8010280b:	66 90                	xchg   %ax,%ax
8010280d:	66 90                	xchg   %ax,%ax
8010280f:	90                   	nop

80102810 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102810:	a1 80 26 11 80       	mov    0x80112680,%eax
80102815:	85 c0                	test   %eax,%eax
80102817:	0f 84 cb 00 00 00    	je     801028e8 <lapicinit+0xd8>
  lapic[index] = value;
8010281d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102824:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102827:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010282a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102831:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102834:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102837:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010283e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102841:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102844:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010284b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010284e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102851:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102858:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010285b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010285e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102865:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102868:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010286b:	8b 50 30             	mov    0x30(%eax),%edx
8010286e:	c1 ea 10             	shr    $0x10,%edx
80102871:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102877:	75 77                	jne    801028f0 <lapicinit+0xe0>
  lapic[index] = value;
80102879:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102880:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102883:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102886:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010288d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102890:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102893:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010289a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010289d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028a0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028a7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028aa:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028ad:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801028b4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028b7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028ba:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801028c1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801028c4:	8b 50 20             	mov    0x20(%eax),%edx
801028c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028ce:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801028d0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801028d6:	80 e6 10             	and    $0x10,%dh
801028d9:	75 f5                	jne    801028d0 <lapicinit+0xc0>
  lapic[index] = value;
801028db:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028e2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028e5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801028e8:	c3                   	ret    
801028e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801028f0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801028f7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028fa:	8b 50 20             	mov    0x20(%eax),%edx
}
801028fd:	e9 77 ff ff ff       	jmp    80102879 <lapicinit+0x69>
80102902:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102910 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102910:	a1 80 26 11 80       	mov    0x80112680,%eax
80102915:	85 c0                	test   %eax,%eax
80102917:	74 07                	je     80102920 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102919:	8b 40 20             	mov    0x20(%eax),%eax
8010291c:	c1 e8 18             	shr    $0x18,%eax
8010291f:	c3                   	ret    
    return 0;
80102920:	31 c0                	xor    %eax,%eax
}
80102922:	c3                   	ret    
80102923:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010292a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102930 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102930:	a1 80 26 11 80       	mov    0x80112680,%eax
80102935:	85 c0                	test   %eax,%eax
80102937:	74 0d                	je     80102946 <lapiceoi+0x16>
  lapic[index] = value;
80102939:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102940:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102943:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102946:	c3                   	ret    
80102947:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010294e:	66 90                	xchg   %ax,%ax

80102950 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102950:	c3                   	ret    
80102951:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010295f:	90                   	nop

80102960 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102960:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102961:	b8 0f 00 00 00       	mov    $0xf,%eax
80102966:	ba 70 00 00 00       	mov    $0x70,%edx
8010296b:	89 e5                	mov    %esp,%ebp
8010296d:	53                   	push   %ebx
8010296e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102971:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102974:	ee                   	out    %al,(%dx)
80102975:	b8 0a 00 00 00       	mov    $0xa,%eax
8010297a:	ba 71 00 00 00       	mov    $0x71,%edx
8010297f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102980:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102982:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102985:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010298b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010298d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102990:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102992:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102995:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102998:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010299e:	a1 80 26 11 80       	mov    0x80112680,%eax
801029a3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029a9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029ac:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801029b3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029b6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029b9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801029c0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029c3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029c6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029cc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029cf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029d5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029d8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029de:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029e1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029e7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801029ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029ed:	c9                   	leave  
801029ee:	c3                   	ret    
801029ef:	90                   	nop

801029f0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029f0:	55                   	push   %ebp
801029f1:	b8 0b 00 00 00       	mov    $0xb,%eax
801029f6:	ba 70 00 00 00       	mov    $0x70,%edx
801029fb:	89 e5                	mov    %esp,%ebp
801029fd:	57                   	push   %edi
801029fe:	56                   	push   %esi
801029ff:	53                   	push   %ebx
80102a00:	83 ec 4c             	sub    $0x4c,%esp
80102a03:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a04:	ba 71 00 00 00       	mov    $0x71,%edx
80102a09:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102a0a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a0d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102a12:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102a15:	8d 76 00             	lea    0x0(%esi),%esi
80102a18:	31 c0                	xor    %eax,%eax
80102a1a:	89 da                	mov    %ebx,%edx
80102a1c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a22:	89 ca                	mov    %ecx,%edx
80102a24:	ec                   	in     (%dx),%al
80102a25:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a28:	89 da                	mov    %ebx,%edx
80102a2a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a2f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a30:	89 ca                	mov    %ecx,%edx
80102a32:	ec                   	in     (%dx),%al
80102a33:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a36:	89 da                	mov    %ebx,%edx
80102a38:	b8 04 00 00 00       	mov    $0x4,%eax
80102a3d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a3e:	89 ca                	mov    %ecx,%edx
80102a40:	ec                   	in     (%dx),%al
80102a41:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a44:	89 da                	mov    %ebx,%edx
80102a46:	b8 07 00 00 00       	mov    $0x7,%eax
80102a4b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a4c:	89 ca                	mov    %ecx,%edx
80102a4e:	ec                   	in     (%dx),%al
80102a4f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a52:	89 da                	mov    %ebx,%edx
80102a54:	b8 08 00 00 00       	mov    $0x8,%eax
80102a59:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a5a:	89 ca                	mov    %ecx,%edx
80102a5c:	ec                   	in     (%dx),%al
80102a5d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a5f:	89 da                	mov    %ebx,%edx
80102a61:	b8 09 00 00 00       	mov    $0x9,%eax
80102a66:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a67:	89 ca                	mov    %ecx,%edx
80102a69:	ec                   	in     (%dx),%al
80102a6a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a6c:	89 da                	mov    %ebx,%edx
80102a6e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a73:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a74:	89 ca                	mov    %ecx,%edx
80102a76:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a77:	84 c0                	test   %al,%al
80102a79:	78 9d                	js     80102a18 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102a7b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a7f:	89 fa                	mov    %edi,%edx
80102a81:	0f b6 fa             	movzbl %dl,%edi
80102a84:	89 f2                	mov    %esi,%edx
80102a86:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a89:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a8d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a90:	89 da                	mov    %ebx,%edx
80102a92:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a95:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a98:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a9c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a9f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102aa2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102aa6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102aa9:	31 c0                	xor    %eax,%eax
80102aab:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aac:	89 ca                	mov    %ecx,%edx
80102aae:	ec                   	in     (%dx),%al
80102aaf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab2:	89 da                	mov    %ebx,%edx
80102ab4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102ab7:	b8 02 00 00 00       	mov    $0x2,%eax
80102abc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102abd:	89 ca                	mov    %ecx,%edx
80102abf:	ec                   	in     (%dx),%al
80102ac0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ac3:	89 da                	mov    %ebx,%edx
80102ac5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102ac8:	b8 04 00 00 00       	mov    $0x4,%eax
80102acd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ace:	89 ca                	mov    %ecx,%edx
80102ad0:	ec                   	in     (%dx),%al
80102ad1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ad4:	89 da                	mov    %ebx,%edx
80102ad6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ad9:	b8 07 00 00 00       	mov    $0x7,%eax
80102ade:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102adf:	89 ca                	mov    %ecx,%edx
80102ae1:	ec                   	in     (%dx),%al
80102ae2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ae5:	89 da                	mov    %ebx,%edx
80102ae7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102aea:	b8 08 00 00 00       	mov    $0x8,%eax
80102aef:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102af0:	89 ca                	mov    %ecx,%edx
80102af2:	ec                   	in     (%dx),%al
80102af3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102af6:	89 da                	mov    %ebx,%edx
80102af8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102afb:	b8 09 00 00 00       	mov    $0x9,%eax
80102b00:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b01:	89 ca                	mov    %ecx,%edx
80102b03:	ec                   	in     (%dx),%al
80102b04:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b07:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102b0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b0d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102b10:	6a 18                	push   $0x18
80102b12:	50                   	push   %eax
80102b13:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102b16:	50                   	push   %eax
80102b17:	e8 94 20 00 00       	call   80104bb0 <memcmp>
80102b1c:	83 c4 10             	add    $0x10,%esp
80102b1f:	85 c0                	test   %eax,%eax
80102b21:	0f 85 f1 fe ff ff    	jne    80102a18 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102b27:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102b2b:	75 78                	jne    80102ba5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b2d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b30:	89 c2                	mov    %eax,%edx
80102b32:	83 e0 0f             	and    $0xf,%eax
80102b35:	c1 ea 04             	shr    $0x4,%edx
80102b38:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b3b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b3e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b41:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b44:	89 c2                	mov    %eax,%edx
80102b46:	83 e0 0f             	and    $0xf,%eax
80102b49:	c1 ea 04             	shr    $0x4,%edx
80102b4c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b4f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b52:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b55:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b58:	89 c2                	mov    %eax,%edx
80102b5a:	83 e0 0f             	and    $0xf,%eax
80102b5d:	c1 ea 04             	shr    $0x4,%edx
80102b60:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b63:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b66:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b69:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b6c:	89 c2                	mov    %eax,%edx
80102b6e:	83 e0 0f             	and    $0xf,%eax
80102b71:	c1 ea 04             	shr    $0x4,%edx
80102b74:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b77:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b7a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b7d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b80:	89 c2                	mov    %eax,%edx
80102b82:	83 e0 0f             	and    $0xf,%eax
80102b85:	c1 ea 04             	shr    $0x4,%edx
80102b88:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b8b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b8e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b91:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b94:	89 c2                	mov    %eax,%edx
80102b96:	83 e0 0f             	and    $0xf,%eax
80102b99:	c1 ea 04             	shr    $0x4,%edx
80102b9c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b9f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ba2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102ba5:	8b 75 08             	mov    0x8(%ebp),%esi
80102ba8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102bab:	89 06                	mov    %eax,(%esi)
80102bad:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102bb0:	89 46 04             	mov    %eax,0x4(%esi)
80102bb3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102bb6:	89 46 08             	mov    %eax,0x8(%esi)
80102bb9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bbc:	89 46 0c             	mov    %eax,0xc(%esi)
80102bbf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102bc2:	89 46 10             	mov    %eax,0x10(%esi)
80102bc5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102bc8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102bcb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102bd2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bd5:	5b                   	pop    %ebx
80102bd6:	5e                   	pop    %esi
80102bd7:	5f                   	pop    %edi
80102bd8:	5d                   	pop    %ebp
80102bd9:	c3                   	ret    
80102bda:	66 90                	xchg   %ax,%ax
80102bdc:	66 90                	xchg   %ax,%ax
80102bde:	66 90                	xchg   %ax,%ax

80102be0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102be0:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102be6:	85 c9                	test   %ecx,%ecx
80102be8:	0f 8e 8a 00 00 00    	jle    80102c78 <install_trans+0x98>
{
80102bee:	55                   	push   %ebp
80102bef:	89 e5                	mov    %esp,%ebp
80102bf1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102bf2:	31 ff                	xor    %edi,%edi
{
80102bf4:	56                   	push   %esi
80102bf5:	53                   	push   %ebx
80102bf6:	83 ec 0c             	sub    $0xc,%esp
80102bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102c00:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102c05:	83 ec 08             	sub    $0x8,%esp
80102c08:	01 f8                	add    %edi,%eax
80102c0a:	83 c0 01             	add    $0x1,%eax
80102c0d:	50                   	push   %eax
80102c0e:	ff 35 e4 26 11 80    	push   0x801126e4
80102c14:	e8 b7 d4 ff ff       	call   801000d0 <bread>
80102c19:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c1b:	58                   	pop    %eax
80102c1c:	5a                   	pop    %edx
80102c1d:	ff 34 bd ec 26 11 80 	push   -0x7feed914(,%edi,4)
80102c24:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c2a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c2d:	e8 9e d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c32:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c35:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c37:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c3a:	68 00 02 00 00       	push   $0x200
80102c3f:	50                   	push   %eax
80102c40:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c43:	50                   	push   %eax
80102c44:	e8 b7 1f 00 00       	call   80104c00 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c49:	89 1c 24             	mov    %ebx,(%esp)
80102c4c:	e8 5f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c51:	89 34 24             	mov    %esi,(%esp)
80102c54:	e8 97 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c59:	89 1c 24             	mov    %ebx,(%esp)
80102c5c:	e8 8f d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c61:	83 c4 10             	add    $0x10,%esp
80102c64:	39 3d e8 26 11 80    	cmp    %edi,0x801126e8
80102c6a:	7f 94                	jg     80102c00 <install_trans+0x20>
  }
}
80102c6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c6f:	5b                   	pop    %ebx
80102c70:	5e                   	pop    %esi
80102c71:	5f                   	pop    %edi
80102c72:	5d                   	pop    %ebp
80102c73:	c3                   	ret    
80102c74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c78:	c3                   	ret    
80102c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c80 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c80:	55                   	push   %ebp
80102c81:	89 e5                	mov    %esp,%ebp
80102c83:	53                   	push   %ebx
80102c84:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c87:	ff 35 d4 26 11 80    	push   0x801126d4
80102c8d:	ff 35 e4 26 11 80    	push   0x801126e4
80102c93:	e8 38 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c98:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c9b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c9d:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80102ca2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102ca5:	85 c0                	test   %eax,%eax
80102ca7:	7e 19                	jle    80102cc2 <write_head+0x42>
80102ca9:	31 d2                	xor    %edx,%edx
80102cab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102caf:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102cb0:	8b 0c 95 ec 26 11 80 	mov    -0x7feed914(,%edx,4),%ecx
80102cb7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102cbb:	83 c2 01             	add    $0x1,%edx
80102cbe:	39 d0                	cmp    %edx,%eax
80102cc0:	75 ee                	jne    80102cb0 <write_head+0x30>
  }
  bwrite(buf);
80102cc2:	83 ec 0c             	sub    $0xc,%esp
80102cc5:	53                   	push   %ebx
80102cc6:	e8 e5 d4 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102ccb:	89 1c 24             	mov    %ebx,(%esp)
80102cce:	e8 1d d5 ff ff       	call   801001f0 <brelse>
}
80102cd3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cd6:	83 c4 10             	add    $0x10,%esp
80102cd9:	c9                   	leave  
80102cda:	c3                   	ret    
80102cdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cdf:	90                   	nop

80102ce0 <initlog>:
{
80102ce0:	55                   	push   %ebp
80102ce1:	89 e5                	mov    %esp,%ebp
80102ce3:	53                   	push   %ebx
80102ce4:	83 ec 2c             	sub    $0x2c,%esp
80102ce7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102cea:	68 40 7d 10 80       	push   $0x80107d40
80102cef:	68 a0 26 11 80       	push   $0x801126a0
80102cf4:	e8 d7 1b 00 00       	call   801048d0 <initlock>
  readsb(dev, &sb);
80102cf9:	58                   	pop    %eax
80102cfa:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cfd:	5a                   	pop    %edx
80102cfe:	50                   	push   %eax
80102cff:	53                   	push   %ebx
80102d00:	e8 3b e8 ff ff       	call   80101540 <readsb>
  log.start = sb.logstart;
80102d05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102d08:	59                   	pop    %ecx
  log.dev = dev;
80102d09:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4
  log.size = sb.nlog;
80102d0f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102d12:	a3 d4 26 11 80       	mov    %eax,0x801126d4
  log.size = sb.nlog;
80102d17:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
  struct buf *buf = bread(log.dev, log.start);
80102d1d:	5a                   	pop    %edx
80102d1e:	50                   	push   %eax
80102d1f:	53                   	push   %ebx
80102d20:	e8 ab d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d25:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d28:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102d2b:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102d31:	85 db                	test   %ebx,%ebx
80102d33:	7e 1d                	jle    80102d52 <initlog+0x72>
80102d35:	31 d2                	xor    %edx,%edx
80102d37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d3e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102d40:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102d44:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d4b:	83 c2 01             	add    $0x1,%edx
80102d4e:	39 d3                	cmp    %edx,%ebx
80102d50:	75 ee                	jne    80102d40 <initlog+0x60>
  brelse(buf);
80102d52:	83 ec 0c             	sub    $0xc,%esp
80102d55:	50                   	push   %eax
80102d56:	e8 95 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d5b:	e8 80 fe ff ff       	call   80102be0 <install_trans>
  log.lh.n = 0;
80102d60:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102d67:	00 00 00 
  write_head(); // clear the log
80102d6a:	e8 11 ff ff ff       	call   80102c80 <write_head>
}
80102d6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d72:	83 c4 10             	add    $0x10,%esp
80102d75:	c9                   	leave  
80102d76:	c3                   	ret    
80102d77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d7e:	66 90                	xchg   %ax,%ax

80102d80 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d80:	55                   	push   %ebp
80102d81:	89 e5                	mov    %esp,%ebp
80102d83:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d86:	68 a0 26 11 80       	push   $0x801126a0
80102d8b:	e8 10 1d 00 00       	call   80104aa0 <acquire>
80102d90:	83 c4 10             	add    $0x10,%esp
80102d93:	eb 18                	jmp    80102dad <begin_op+0x2d>
80102d95:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d98:	83 ec 08             	sub    $0x8,%esp
80102d9b:	68 a0 26 11 80       	push   $0x801126a0
80102da0:	68 a0 26 11 80       	push   $0x801126a0
80102da5:	e8 56 13 00 00       	call   80104100 <sleep>
80102daa:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102dad:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102db2:	85 c0                	test   %eax,%eax
80102db4:	75 e2                	jne    80102d98 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102db6:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102dbb:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102dc1:	83 c0 01             	add    $0x1,%eax
80102dc4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102dc7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102dca:	83 fa 1e             	cmp    $0x1e,%edx
80102dcd:	7f c9                	jg     80102d98 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102dcf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102dd2:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80102dd7:	68 a0 26 11 80       	push   $0x801126a0
80102ddc:	e8 5f 1c 00 00       	call   80104a40 <release>
      break;
    }
  }
}
80102de1:	83 c4 10             	add    $0x10,%esp
80102de4:	c9                   	leave  
80102de5:	c3                   	ret    
80102de6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ded:	8d 76 00             	lea    0x0(%esi),%esi

80102df0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102df0:	55                   	push   %ebp
80102df1:	89 e5                	mov    %esp,%ebp
80102df3:	57                   	push   %edi
80102df4:	56                   	push   %esi
80102df5:	53                   	push   %ebx
80102df6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102df9:	68 a0 26 11 80       	push   $0x801126a0
80102dfe:	e8 9d 1c 00 00       	call   80104aa0 <acquire>
  log.outstanding -= 1;
80102e03:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80102e08:	8b 35 e0 26 11 80    	mov    0x801126e0,%esi
80102e0e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102e11:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102e14:	89 1d dc 26 11 80    	mov    %ebx,0x801126dc
  if(log.committing)
80102e1a:	85 f6                	test   %esi,%esi
80102e1c:	0f 85 22 01 00 00    	jne    80102f44 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e22:	85 db                	test   %ebx,%ebx
80102e24:	0f 85 f6 00 00 00    	jne    80102f20 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e2a:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102e31:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e34:	83 ec 0c             	sub    $0xc,%esp
80102e37:	68 a0 26 11 80       	push   $0x801126a0
80102e3c:	e8 ff 1b 00 00       	call   80104a40 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e41:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102e47:	83 c4 10             	add    $0x10,%esp
80102e4a:	85 c9                	test   %ecx,%ecx
80102e4c:	7f 42                	jg     80102e90 <end_op+0xa0>
    acquire(&log.lock);
80102e4e:	83 ec 0c             	sub    $0xc,%esp
80102e51:	68 a0 26 11 80       	push   $0x801126a0
80102e56:	e8 45 1c 00 00       	call   80104aa0 <acquire>
    wakeup(&log);
80102e5b:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
    log.committing = 0;
80102e62:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102e69:	00 00 00 
    wakeup(&log);
80102e6c:	e8 4f 13 00 00       	call   801041c0 <wakeup>
    release(&log.lock);
80102e71:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102e78:	e8 c3 1b 00 00       	call   80104a40 <release>
80102e7d:	83 c4 10             	add    $0x10,%esp
}
80102e80:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e83:	5b                   	pop    %ebx
80102e84:	5e                   	pop    %esi
80102e85:	5f                   	pop    %edi
80102e86:	5d                   	pop    %ebp
80102e87:	c3                   	ret    
80102e88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e8f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e90:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102e95:	83 ec 08             	sub    $0x8,%esp
80102e98:	01 d8                	add    %ebx,%eax
80102e9a:	83 c0 01             	add    $0x1,%eax
80102e9d:	50                   	push   %eax
80102e9e:	ff 35 e4 26 11 80    	push   0x801126e4
80102ea4:	e8 27 d2 ff ff       	call   801000d0 <bread>
80102ea9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102eab:	58                   	pop    %eax
80102eac:	5a                   	pop    %edx
80102ead:	ff 34 9d ec 26 11 80 	push   -0x7feed914(,%ebx,4)
80102eb4:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102eba:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ebd:	e8 0e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102ec2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ec5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ec7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102eca:	68 00 02 00 00       	push   $0x200
80102ecf:	50                   	push   %eax
80102ed0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102ed3:	50                   	push   %eax
80102ed4:	e8 27 1d 00 00       	call   80104c00 <memmove>
    bwrite(to);  // write the log
80102ed9:	89 34 24             	mov    %esi,(%esp)
80102edc:	e8 cf d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ee1:	89 3c 24             	mov    %edi,(%esp)
80102ee4:	e8 07 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ee9:	89 34 24             	mov    %esi,(%esp)
80102eec:	e8 ff d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ef1:	83 c4 10             	add    $0x10,%esp
80102ef4:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
80102efa:	7c 94                	jl     80102e90 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102efc:	e8 7f fd ff ff       	call   80102c80 <write_head>
    install_trans(); // Now install writes to home locations
80102f01:	e8 da fc ff ff       	call   80102be0 <install_trans>
    log.lh.n = 0;
80102f06:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102f0d:	00 00 00 
    write_head();    // Erase the transaction from the log
80102f10:	e8 6b fd ff ff       	call   80102c80 <write_head>
80102f15:	e9 34 ff ff ff       	jmp    80102e4e <end_op+0x5e>
80102f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f20:	83 ec 0c             	sub    $0xc,%esp
80102f23:	68 a0 26 11 80       	push   $0x801126a0
80102f28:	e8 93 12 00 00       	call   801041c0 <wakeup>
  release(&log.lock);
80102f2d:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102f34:	e8 07 1b 00 00       	call   80104a40 <release>
80102f39:	83 c4 10             	add    $0x10,%esp
}
80102f3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f3f:	5b                   	pop    %ebx
80102f40:	5e                   	pop    %esi
80102f41:	5f                   	pop    %edi
80102f42:	5d                   	pop    %ebp
80102f43:	c3                   	ret    
    panic("log.committing");
80102f44:	83 ec 0c             	sub    $0xc,%esp
80102f47:	68 44 7d 10 80       	push   $0x80107d44
80102f4c:	e8 2f d4 ff ff       	call   80100380 <panic>
80102f51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f5f:	90                   	nop

80102f60 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f60:	55                   	push   %ebp
80102f61:	89 e5                	mov    %esp,%ebp
80102f63:	53                   	push   %ebx
80102f64:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f67:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
{
80102f6d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f70:	83 fa 1d             	cmp    $0x1d,%edx
80102f73:	0f 8f 85 00 00 00    	jg     80102ffe <log_write+0x9e>
80102f79:	a1 d8 26 11 80       	mov    0x801126d8,%eax
80102f7e:	83 e8 01             	sub    $0x1,%eax
80102f81:	39 c2                	cmp    %eax,%edx
80102f83:	7d 79                	jge    80102ffe <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f85:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102f8a:	85 c0                	test   %eax,%eax
80102f8c:	7e 7d                	jle    8010300b <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f8e:	83 ec 0c             	sub    $0xc,%esp
80102f91:	68 a0 26 11 80       	push   $0x801126a0
80102f96:	e8 05 1b 00 00       	call   80104aa0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f9b:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102fa1:	83 c4 10             	add    $0x10,%esp
80102fa4:	85 d2                	test   %edx,%edx
80102fa6:	7e 4a                	jle    80102ff2 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fa8:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102fab:	31 c0                	xor    %eax,%eax
80102fad:	eb 08                	jmp    80102fb7 <log_write+0x57>
80102faf:	90                   	nop
80102fb0:	83 c0 01             	add    $0x1,%eax
80102fb3:	39 c2                	cmp    %eax,%edx
80102fb5:	74 29                	je     80102fe0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fb7:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
80102fbe:	75 f0                	jne    80102fb0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80102fc0:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102fc7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102fca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102fcd:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80102fd4:	c9                   	leave  
  release(&log.lock);
80102fd5:	e9 66 1a 00 00       	jmp    80104a40 <release>
80102fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fe0:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
    log.lh.n++;
80102fe7:	83 c2 01             	add    $0x1,%edx
80102fea:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
80102ff0:	eb d5                	jmp    80102fc7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80102ff2:	8b 43 08             	mov    0x8(%ebx),%eax
80102ff5:	a3 ec 26 11 80       	mov    %eax,0x801126ec
  if (i == log.lh.n)
80102ffa:	75 cb                	jne    80102fc7 <log_write+0x67>
80102ffc:	eb e9                	jmp    80102fe7 <log_write+0x87>
    panic("too big a transaction");
80102ffe:	83 ec 0c             	sub    $0xc,%esp
80103001:	68 53 7d 10 80       	push   $0x80107d53
80103006:	e8 75 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
8010300b:	83 ec 0c             	sub    $0xc,%esp
8010300e:	68 69 7d 10 80       	push   $0x80107d69
80103013:	e8 68 d3 ff ff       	call   80100380 <panic>
80103018:	66 90                	xchg   %ax,%ax
8010301a:	66 90                	xchg   %ax,%ax
8010301c:	66 90                	xchg   %ax,%ax
8010301e:	66 90                	xchg   %ax,%ax

80103020 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103020:	55                   	push   %ebp
80103021:	89 e5                	mov    %esp,%ebp
80103023:	53                   	push   %ebx
80103024:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103027:	e8 c4 09 00 00       	call   801039f0 <cpuid>
8010302c:	89 c3                	mov    %eax,%ebx
8010302e:	e8 bd 09 00 00       	call   801039f0 <cpuid>
80103033:	83 ec 04             	sub    $0x4,%esp
80103036:	53                   	push   %ebx
80103037:	50                   	push   %eax
80103038:	68 84 7d 10 80       	push   $0x80107d84
8010303d:	e8 5e d6 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103042:	e8 29 2f 00 00       	call   80105f70 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103047:	e8 44 09 00 00       	call   80103990 <mycpu>
8010304c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010304e:	b8 01 00 00 00       	mov    $0x1,%eax
80103053:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010305a:	e8 91 0c 00 00       	call   80103cf0 <scheduler>
8010305f:	90                   	nop

80103060 <mpenter>:
{
80103060:	55                   	push   %ebp
80103061:	89 e5                	mov    %esp,%ebp
80103063:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103066:	e8 65 40 00 00       	call   801070d0 <switchkvm>
  seginit();
8010306b:	e8 d0 3f 00 00       	call   80107040 <seginit>
  lapicinit();
80103070:	e8 9b f7 ff ff       	call   80102810 <lapicinit>
  mpmain();
80103075:	e8 a6 ff ff ff       	call   80103020 <mpmain>
8010307a:	66 90                	xchg   %ax,%ax
8010307c:	66 90                	xchg   %ax,%ax
8010307e:	66 90                	xchg   %ax,%ax

80103080 <main>:
{
80103080:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103084:	83 e4 f0             	and    $0xfffffff0,%esp
80103087:	ff 71 fc             	push   -0x4(%ecx)
8010308a:	55                   	push   %ebp
8010308b:	89 e5                	mov    %esp,%ebp
8010308d:	53                   	push   %ebx
8010308e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010308f:	83 ec 08             	sub    $0x8,%esp
80103092:	68 00 00 40 80       	push   $0x80400000
80103097:	68 d0 68 11 80       	push   $0x801168d0
8010309c:	e8 8f f5 ff ff       	call   80102630 <kinit1>
  kvmalloc();      // kernel page table
801030a1:	e8 1a 45 00 00       	call   801075c0 <kvmalloc>
  mpinit();        // detect other processors
801030a6:	e8 85 01 00 00       	call   80103230 <mpinit>
  lapicinit();     // interrupt controller
801030ab:	e8 60 f7 ff ff       	call   80102810 <lapicinit>
  seginit();       // segment descriptors
801030b0:	e8 8b 3f 00 00       	call   80107040 <seginit>
  picinit();       // disable pic
801030b5:	e8 76 03 00 00       	call   80103430 <picinit>
  ioapicinit();    // another interrupt controller
801030ba:	e8 31 f3 ff ff       	call   801023f0 <ioapicinit>
  consoleinit();   // console hardware
801030bf:	e8 9c d9 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
801030c4:	e8 07 32 00 00       	call   801062d0 <uartinit>
  pinit();         // process table
801030c9:	e8 a2 08 00 00       	call   80103970 <pinit>
  tvinit();        // trap vectors
801030ce:	e8 1d 2e 00 00       	call   80105ef0 <tvinit>
  binit();         // buffer cache
801030d3:	e8 68 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030d8:	e8 53 dd ff ff       	call   80100e30 <fileinit>
  ideinit();       // disk 
801030dd:	e8 fe f0 ff ff       	call   801021e0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030e2:	83 c4 0c             	add    $0xc,%esp
801030e5:	68 8a 00 00 00       	push   $0x8a
801030ea:	68 8c b4 10 80       	push   $0x8010b48c
801030ef:	68 00 70 00 80       	push   $0x80007000
801030f4:	e8 07 1b 00 00       	call   80104c00 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030f9:	83 c4 10             	add    $0x10,%esp
801030fc:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
80103103:	00 00 00 
80103106:	05 a0 27 11 80       	add    $0x801127a0,%eax
8010310b:	3d a0 27 11 80       	cmp    $0x801127a0,%eax
80103110:	76 7e                	jbe    80103190 <main+0x110>
80103112:	bb a0 27 11 80       	mov    $0x801127a0,%ebx
80103117:	eb 20                	jmp    80103139 <main+0xb9>
80103119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103120:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
80103127:	00 00 00 
8010312a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103130:	05 a0 27 11 80       	add    $0x801127a0,%eax
80103135:	39 c3                	cmp    %eax,%ebx
80103137:	73 57                	jae    80103190 <main+0x110>
    if(c == mycpu())  // We've started already.
80103139:	e8 52 08 00 00       	call   80103990 <mycpu>
8010313e:	39 c3                	cmp    %eax,%ebx
80103140:	74 de                	je     80103120 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103142:	e8 59 f5 ff ff       	call   801026a0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103147:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010314a:	c7 05 f8 6f 00 80 60 	movl   $0x80103060,0x80006ff8
80103151:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103154:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010315b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010315e:	05 00 10 00 00       	add    $0x1000,%eax
80103163:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103168:	0f b6 03             	movzbl (%ebx),%eax
8010316b:	68 00 70 00 00       	push   $0x7000
80103170:	50                   	push   %eax
80103171:	e8 ea f7 ff ff       	call   80102960 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103176:	83 c4 10             	add    $0x10,%esp
80103179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103180:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103186:	85 c0                	test   %eax,%eax
80103188:	74 f6                	je     80103180 <main+0x100>
8010318a:	eb 94                	jmp    80103120 <main+0xa0>
8010318c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103190:	83 ec 08             	sub    $0x8,%esp
80103193:	68 00 00 00 8e       	push   $0x8e000000
80103198:	68 00 00 40 80       	push   $0x80400000
8010319d:	e8 2e f4 ff ff       	call   801025d0 <kinit2>
  userinit();      // first user process
801031a2:	e8 99 08 00 00       	call   80103a40 <userinit>
  mpmain();        // finish this processor's setup
801031a7:	e8 74 fe ff ff       	call   80103020 <mpmain>
801031ac:	66 90                	xchg   %ax,%ax
801031ae:	66 90                	xchg   %ax,%ax

801031b0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801031b0:	55                   	push   %ebp
801031b1:	89 e5                	mov    %esp,%ebp
801031b3:	57                   	push   %edi
801031b4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801031b5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801031bb:	53                   	push   %ebx
  e = addr+len;
801031bc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801031bf:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801031c2:	39 de                	cmp    %ebx,%esi
801031c4:	72 10                	jb     801031d6 <mpsearch1+0x26>
801031c6:	eb 50                	jmp    80103218 <mpsearch1+0x68>
801031c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031cf:	90                   	nop
801031d0:	89 fe                	mov    %edi,%esi
801031d2:	39 fb                	cmp    %edi,%ebx
801031d4:	76 42                	jbe    80103218 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031d6:	83 ec 04             	sub    $0x4,%esp
801031d9:	8d 7e 10             	lea    0x10(%esi),%edi
801031dc:	6a 04                	push   $0x4
801031de:	68 98 7d 10 80       	push   $0x80107d98
801031e3:	56                   	push   %esi
801031e4:	e8 c7 19 00 00       	call   80104bb0 <memcmp>
801031e9:	83 c4 10             	add    $0x10,%esp
801031ec:	85 c0                	test   %eax,%eax
801031ee:	75 e0                	jne    801031d0 <mpsearch1+0x20>
801031f0:	89 f2                	mov    %esi,%edx
801031f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031f8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801031fb:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801031fe:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103200:	39 fa                	cmp    %edi,%edx
80103202:	75 f4                	jne    801031f8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103204:	84 c0                	test   %al,%al
80103206:	75 c8                	jne    801031d0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103208:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010320b:	89 f0                	mov    %esi,%eax
8010320d:	5b                   	pop    %ebx
8010320e:	5e                   	pop    %esi
8010320f:	5f                   	pop    %edi
80103210:	5d                   	pop    %ebp
80103211:	c3                   	ret    
80103212:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103218:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010321b:	31 f6                	xor    %esi,%esi
}
8010321d:	5b                   	pop    %ebx
8010321e:	89 f0                	mov    %esi,%eax
80103220:	5e                   	pop    %esi
80103221:	5f                   	pop    %edi
80103222:	5d                   	pop    %ebp
80103223:	c3                   	ret    
80103224:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010322b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010322f:	90                   	nop

80103230 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103230:	55                   	push   %ebp
80103231:	89 e5                	mov    %esp,%ebp
80103233:	57                   	push   %edi
80103234:	56                   	push   %esi
80103235:	53                   	push   %ebx
80103236:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103239:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103240:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103247:	c1 e0 08             	shl    $0x8,%eax
8010324a:	09 d0                	or     %edx,%eax
8010324c:	c1 e0 04             	shl    $0x4,%eax
8010324f:	75 1b                	jne    8010326c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103251:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103258:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010325f:	c1 e0 08             	shl    $0x8,%eax
80103262:	09 d0                	or     %edx,%eax
80103264:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103267:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010326c:	ba 00 04 00 00       	mov    $0x400,%edx
80103271:	e8 3a ff ff ff       	call   801031b0 <mpsearch1>
80103276:	89 c3                	mov    %eax,%ebx
80103278:	85 c0                	test   %eax,%eax
8010327a:	0f 84 40 01 00 00    	je     801033c0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103280:	8b 73 04             	mov    0x4(%ebx),%esi
80103283:	85 f6                	test   %esi,%esi
80103285:	0f 84 25 01 00 00    	je     801033b0 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010328b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010328e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103294:	6a 04                	push   $0x4
80103296:	68 9d 7d 10 80       	push   $0x80107d9d
8010329b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010329c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010329f:	e8 0c 19 00 00       	call   80104bb0 <memcmp>
801032a4:	83 c4 10             	add    $0x10,%esp
801032a7:	85 c0                	test   %eax,%eax
801032a9:	0f 85 01 01 00 00    	jne    801033b0 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
801032af:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801032b6:	3c 01                	cmp    $0x1,%al
801032b8:	74 08                	je     801032c2 <mpinit+0x92>
801032ba:	3c 04                	cmp    $0x4,%al
801032bc:	0f 85 ee 00 00 00    	jne    801033b0 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
801032c2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801032c9:	66 85 d2             	test   %dx,%dx
801032cc:	74 22                	je     801032f0 <mpinit+0xc0>
801032ce:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801032d1:	89 f0                	mov    %esi,%eax
  sum = 0;
801032d3:	31 d2                	xor    %edx,%edx
801032d5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801032d8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801032df:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801032e2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032e4:	39 c7                	cmp    %eax,%edi
801032e6:	75 f0                	jne    801032d8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801032e8:	84 d2                	test   %dl,%dl
801032ea:	0f 85 c0 00 00 00    	jne    801033b0 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032f0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801032f6:	a3 80 26 11 80       	mov    %eax,0x80112680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032fb:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103302:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
80103308:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010330d:	03 55 e4             	add    -0x1c(%ebp),%edx
80103310:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103313:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103317:	90                   	nop
80103318:	39 d0                	cmp    %edx,%eax
8010331a:	73 15                	jae    80103331 <mpinit+0x101>
    switch(*p){
8010331c:	0f b6 08             	movzbl (%eax),%ecx
8010331f:	80 f9 02             	cmp    $0x2,%cl
80103322:	74 4c                	je     80103370 <mpinit+0x140>
80103324:	77 3a                	ja     80103360 <mpinit+0x130>
80103326:	84 c9                	test   %cl,%cl
80103328:	74 56                	je     80103380 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010332a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010332d:	39 d0                	cmp    %edx,%eax
8010332f:	72 eb                	jb     8010331c <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103331:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103334:	85 f6                	test   %esi,%esi
80103336:	0f 84 d9 00 00 00    	je     80103415 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010333c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103340:	74 15                	je     80103357 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103342:	b8 70 00 00 00       	mov    $0x70,%eax
80103347:	ba 22 00 00 00       	mov    $0x22,%edx
8010334c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010334d:	ba 23 00 00 00       	mov    $0x23,%edx
80103352:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103353:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103356:	ee                   	out    %al,(%dx)
  }
}
80103357:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010335a:	5b                   	pop    %ebx
8010335b:	5e                   	pop    %esi
8010335c:	5f                   	pop    %edi
8010335d:	5d                   	pop    %ebp
8010335e:	c3                   	ret    
8010335f:	90                   	nop
    switch(*p){
80103360:	83 e9 03             	sub    $0x3,%ecx
80103363:	80 f9 01             	cmp    $0x1,%cl
80103366:	76 c2                	jbe    8010332a <mpinit+0xfa>
80103368:	31 f6                	xor    %esi,%esi
8010336a:	eb ac                	jmp    80103318 <mpinit+0xe8>
8010336c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103370:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103374:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103377:	88 0d 80 27 11 80    	mov    %cl,0x80112780
      continue;
8010337d:	eb 99                	jmp    80103318 <mpinit+0xe8>
8010337f:	90                   	nop
      if(ncpu < NCPU) {
80103380:	8b 0d 84 27 11 80    	mov    0x80112784,%ecx
80103386:	83 f9 07             	cmp    $0x7,%ecx
80103389:	7f 19                	jg     801033a4 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010338b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103391:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103395:	83 c1 01             	add    $0x1,%ecx
80103398:	89 0d 84 27 11 80    	mov    %ecx,0x80112784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010339e:	88 9f a0 27 11 80    	mov    %bl,-0x7feed860(%edi)
      p += sizeof(struct mpproc);
801033a4:	83 c0 14             	add    $0x14,%eax
      continue;
801033a7:	e9 6c ff ff ff       	jmp    80103318 <mpinit+0xe8>
801033ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801033b0:	83 ec 0c             	sub    $0xc,%esp
801033b3:	68 a2 7d 10 80       	push   $0x80107da2
801033b8:	e8 c3 cf ff ff       	call   80100380 <panic>
801033bd:	8d 76 00             	lea    0x0(%esi),%esi
{
801033c0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801033c5:	eb 13                	jmp    801033da <mpinit+0x1aa>
801033c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033ce:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
801033d0:	89 f3                	mov    %esi,%ebx
801033d2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801033d8:	74 d6                	je     801033b0 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033da:	83 ec 04             	sub    $0x4,%esp
801033dd:	8d 73 10             	lea    0x10(%ebx),%esi
801033e0:	6a 04                	push   $0x4
801033e2:	68 98 7d 10 80       	push   $0x80107d98
801033e7:	53                   	push   %ebx
801033e8:	e8 c3 17 00 00       	call   80104bb0 <memcmp>
801033ed:	83 c4 10             	add    $0x10,%esp
801033f0:	85 c0                	test   %eax,%eax
801033f2:	75 dc                	jne    801033d0 <mpinit+0x1a0>
801033f4:	89 da                	mov    %ebx,%edx
801033f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033fd:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103400:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103403:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103406:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103408:	39 d6                	cmp    %edx,%esi
8010340a:	75 f4                	jne    80103400 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010340c:	84 c0                	test   %al,%al
8010340e:	75 c0                	jne    801033d0 <mpinit+0x1a0>
80103410:	e9 6b fe ff ff       	jmp    80103280 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103415:	83 ec 0c             	sub    $0xc,%esp
80103418:	68 bc 7d 10 80       	push   $0x80107dbc
8010341d:	e8 5e cf ff ff       	call   80100380 <panic>
80103422:	66 90                	xchg   %ax,%ax
80103424:	66 90                	xchg   %ax,%ax
80103426:	66 90                	xchg   %ax,%ax
80103428:	66 90                	xchg   %ax,%ax
8010342a:	66 90                	xchg   %ax,%ax
8010342c:	66 90                	xchg   %ax,%ax
8010342e:	66 90                	xchg   %ax,%ax

80103430 <picinit>:
80103430:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103435:	ba 21 00 00 00       	mov    $0x21,%edx
8010343a:	ee                   	out    %al,(%dx)
8010343b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103440:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103441:	c3                   	ret    
80103442:	66 90                	xchg   %ax,%ax
80103444:	66 90                	xchg   %ax,%ax
80103446:	66 90                	xchg   %ax,%ax
80103448:	66 90                	xchg   %ax,%ax
8010344a:	66 90                	xchg   %ax,%ax
8010344c:	66 90                	xchg   %ax,%ax
8010344e:	66 90                	xchg   %ax,%ax

80103450 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103450:	55                   	push   %ebp
80103451:	89 e5                	mov    %esp,%ebp
80103453:	57                   	push   %edi
80103454:	56                   	push   %esi
80103455:	53                   	push   %ebx
80103456:	83 ec 0c             	sub    $0xc,%esp
80103459:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010345c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010345f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103465:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010346b:	e8 e0 d9 ff ff       	call   80100e50 <filealloc>
80103470:	89 03                	mov    %eax,(%ebx)
80103472:	85 c0                	test   %eax,%eax
80103474:	0f 84 a8 00 00 00    	je     80103522 <pipealloc+0xd2>
8010347a:	e8 d1 d9 ff ff       	call   80100e50 <filealloc>
8010347f:	89 06                	mov    %eax,(%esi)
80103481:	85 c0                	test   %eax,%eax
80103483:	0f 84 87 00 00 00    	je     80103510 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103489:	e8 12 f2 ff ff       	call   801026a0 <kalloc>
8010348e:	89 c7                	mov    %eax,%edi
80103490:	85 c0                	test   %eax,%eax
80103492:	0f 84 b0 00 00 00    	je     80103548 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103498:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010349f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801034a2:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801034a5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801034ac:	00 00 00 
  p->nwrite = 0;
801034af:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801034b6:	00 00 00 
  p->nread = 0;
801034b9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034c0:	00 00 00 
  initlock(&p->lock, "pipe");
801034c3:	68 db 7d 10 80       	push   $0x80107ddb
801034c8:	50                   	push   %eax
801034c9:	e8 02 14 00 00       	call   801048d0 <initlock>
  (*f0)->type = FD_PIPE;
801034ce:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801034d0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801034d3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801034d9:	8b 03                	mov    (%ebx),%eax
801034db:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034df:	8b 03                	mov    (%ebx),%eax
801034e1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034e5:	8b 03                	mov    (%ebx),%eax
801034e7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034ea:	8b 06                	mov    (%esi),%eax
801034ec:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034f2:	8b 06                	mov    (%esi),%eax
801034f4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034f8:	8b 06                	mov    (%esi),%eax
801034fa:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034fe:	8b 06                	mov    (%esi),%eax
80103500:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103503:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103506:	31 c0                	xor    %eax,%eax
}
80103508:	5b                   	pop    %ebx
80103509:	5e                   	pop    %esi
8010350a:	5f                   	pop    %edi
8010350b:	5d                   	pop    %ebp
8010350c:	c3                   	ret    
8010350d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103510:	8b 03                	mov    (%ebx),%eax
80103512:	85 c0                	test   %eax,%eax
80103514:	74 1e                	je     80103534 <pipealloc+0xe4>
    fileclose(*f0);
80103516:	83 ec 0c             	sub    $0xc,%esp
80103519:	50                   	push   %eax
8010351a:	e8 f1 d9 ff ff       	call   80100f10 <fileclose>
8010351f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103522:	8b 06                	mov    (%esi),%eax
80103524:	85 c0                	test   %eax,%eax
80103526:	74 0c                	je     80103534 <pipealloc+0xe4>
    fileclose(*f1);
80103528:	83 ec 0c             	sub    $0xc,%esp
8010352b:	50                   	push   %eax
8010352c:	e8 df d9 ff ff       	call   80100f10 <fileclose>
80103531:	83 c4 10             	add    $0x10,%esp
}
80103534:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103537:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010353c:	5b                   	pop    %ebx
8010353d:	5e                   	pop    %esi
8010353e:	5f                   	pop    %edi
8010353f:	5d                   	pop    %ebp
80103540:	c3                   	ret    
80103541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103548:	8b 03                	mov    (%ebx),%eax
8010354a:	85 c0                	test   %eax,%eax
8010354c:	75 c8                	jne    80103516 <pipealloc+0xc6>
8010354e:	eb d2                	jmp    80103522 <pipealloc+0xd2>

80103550 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103550:	55                   	push   %ebp
80103551:	89 e5                	mov    %esp,%ebp
80103553:	56                   	push   %esi
80103554:	53                   	push   %ebx
80103555:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103558:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010355b:	83 ec 0c             	sub    $0xc,%esp
8010355e:	53                   	push   %ebx
8010355f:	e8 3c 15 00 00       	call   80104aa0 <acquire>
  if(writable){
80103564:	83 c4 10             	add    $0x10,%esp
80103567:	85 f6                	test   %esi,%esi
80103569:	74 65                	je     801035d0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010356b:	83 ec 0c             	sub    $0xc,%esp
8010356e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103574:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010357b:	00 00 00 
    wakeup(&p->nread);
8010357e:	50                   	push   %eax
8010357f:	e8 3c 0c 00 00       	call   801041c0 <wakeup>
80103584:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103587:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010358d:	85 d2                	test   %edx,%edx
8010358f:	75 0a                	jne    8010359b <pipeclose+0x4b>
80103591:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103597:	85 c0                	test   %eax,%eax
80103599:	74 15                	je     801035b0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010359b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010359e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035a1:	5b                   	pop    %ebx
801035a2:	5e                   	pop    %esi
801035a3:	5d                   	pop    %ebp
    release(&p->lock);
801035a4:	e9 97 14 00 00       	jmp    80104a40 <release>
801035a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801035b0:	83 ec 0c             	sub    $0xc,%esp
801035b3:	53                   	push   %ebx
801035b4:	e8 87 14 00 00       	call   80104a40 <release>
    kfree((char*)p);
801035b9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801035bc:	83 c4 10             	add    $0x10,%esp
}
801035bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035c2:	5b                   	pop    %ebx
801035c3:	5e                   	pop    %esi
801035c4:	5d                   	pop    %ebp
    kfree((char*)p);
801035c5:	e9 16 ef ff ff       	jmp    801024e0 <kfree>
801035ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801035d0:	83 ec 0c             	sub    $0xc,%esp
801035d3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801035d9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801035e0:	00 00 00 
    wakeup(&p->nwrite);
801035e3:	50                   	push   %eax
801035e4:	e8 d7 0b 00 00       	call   801041c0 <wakeup>
801035e9:	83 c4 10             	add    $0x10,%esp
801035ec:	eb 99                	jmp    80103587 <pipeclose+0x37>
801035ee:	66 90                	xchg   %ax,%ax

801035f0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035f0:	55                   	push   %ebp
801035f1:	89 e5                	mov    %esp,%ebp
801035f3:	57                   	push   %edi
801035f4:	56                   	push   %esi
801035f5:	53                   	push   %ebx
801035f6:	83 ec 28             	sub    $0x28,%esp
801035f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035fc:	53                   	push   %ebx
801035fd:	e8 9e 14 00 00       	call   80104aa0 <acquire>
  for(i = 0; i < n; i++){
80103602:	8b 45 10             	mov    0x10(%ebp),%eax
80103605:	83 c4 10             	add    $0x10,%esp
80103608:	85 c0                	test   %eax,%eax
8010360a:	0f 8e c0 00 00 00    	jle    801036d0 <pipewrite+0xe0>
80103610:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103613:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103619:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010361f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103622:	03 45 10             	add    0x10(%ebp),%eax
80103625:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103628:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010362e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103634:	89 ca                	mov    %ecx,%edx
80103636:	05 00 02 00 00       	add    $0x200,%eax
8010363b:	39 c1                	cmp    %eax,%ecx
8010363d:	74 3f                	je     8010367e <pipewrite+0x8e>
8010363f:	eb 67                	jmp    801036a8 <pipewrite+0xb8>
80103641:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103648:	e8 c3 03 00 00       	call   80103a10 <myproc>
8010364d:	8b 48 24             	mov    0x24(%eax),%ecx
80103650:	85 c9                	test   %ecx,%ecx
80103652:	75 34                	jne    80103688 <pipewrite+0x98>
      wakeup(&p->nread);
80103654:	83 ec 0c             	sub    $0xc,%esp
80103657:	57                   	push   %edi
80103658:	e8 63 0b 00 00       	call   801041c0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010365d:	58                   	pop    %eax
8010365e:	5a                   	pop    %edx
8010365f:	53                   	push   %ebx
80103660:	56                   	push   %esi
80103661:	e8 9a 0a 00 00       	call   80104100 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103666:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010366c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103672:	83 c4 10             	add    $0x10,%esp
80103675:	05 00 02 00 00       	add    $0x200,%eax
8010367a:	39 c2                	cmp    %eax,%edx
8010367c:	75 2a                	jne    801036a8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010367e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103684:	85 c0                	test   %eax,%eax
80103686:	75 c0                	jne    80103648 <pipewrite+0x58>
        release(&p->lock);
80103688:	83 ec 0c             	sub    $0xc,%esp
8010368b:	53                   	push   %ebx
8010368c:	e8 af 13 00 00       	call   80104a40 <release>
        return -1;
80103691:	83 c4 10             	add    $0x10,%esp
80103694:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103699:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010369c:	5b                   	pop    %ebx
8010369d:	5e                   	pop    %esi
8010369e:	5f                   	pop    %edi
8010369f:	5d                   	pop    %ebp
801036a0:	c3                   	ret    
801036a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036a8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801036ab:	8d 4a 01             	lea    0x1(%edx),%ecx
801036ae:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801036b4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
801036ba:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
801036bd:	83 c6 01             	add    $0x1,%esi
801036c0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036c3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801036c7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801036ca:	0f 85 58 ff ff ff    	jne    80103628 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036d0:	83 ec 0c             	sub    $0xc,%esp
801036d3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036d9:	50                   	push   %eax
801036da:	e8 e1 0a 00 00       	call   801041c0 <wakeup>
  release(&p->lock);
801036df:	89 1c 24             	mov    %ebx,(%esp)
801036e2:	e8 59 13 00 00       	call   80104a40 <release>
  return n;
801036e7:	8b 45 10             	mov    0x10(%ebp),%eax
801036ea:	83 c4 10             	add    $0x10,%esp
801036ed:	eb aa                	jmp    80103699 <pipewrite+0xa9>
801036ef:	90                   	nop

801036f0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036f0:	55                   	push   %ebp
801036f1:	89 e5                	mov    %esp,%ebp
801036f3:	57                   	push   %edi
801036f4:	56                   	push   %esi
801036f5:	53                   	push   %ebx
801036f6:	83 ec 18             	sub    $0x18,%esp
801036f9:	8b 75 08             	mov    0x8(%ebp),%esi
801036fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036ff:	56                   	push   %esi
80103700:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103706:	e8 95 13 00 00       	call   80104aa0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010370b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103711:	83 c4 10             	add    $0x10,%esp
80103714:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010371a:	74 2f                	je     8010374b <piperead+0x5b>
8010371c:	eb 37                	jmp    80103755 <piperead+0x65>
8010371e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103720:	e8 eb 02 00 00       	call   80103a10 <myproc>
80103725:	8b 48 24             	mov    0x24(%eax),%ecx
80103728:	85 c9                	test   %ecx,%ecx
8010372a:	0f 85 80 00 00 00    	jne    801037b0 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103730:	83 ec 08             	sub    $0x8,%esp
80103733:	56                   	push   %esi
80103734:	53                   	push   %ebx
80103735:	e8 c6 09 00 00       	call   80104100 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010373a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103740:	83 c4 10             	add    $0x10,%esp
80103743:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103749:	75 0a                	jne    80103755 <piperead+0x65>
8010374b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103751:	85 c0                	test   %eax,%eax
80103753:	75 cb                	jne    80103720 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103755:	8b 55 10             	mov    0x10(%ebp),%edx
80103758:	31 db                	xor    %ebx,%ebx
8010375a:	85 d2                	test   %edx,%edx
8010375c:	7f 20                	jg     8010377e <piperead+0x8e>
8010375e:	eb 2c                	jmp    8010378c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103760:	8d 48 01             	lea    0x1(%eax),%ecx
80103763:	25 ff 01 00 00       	and    $0x1ff,%eax
80103768:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010376e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103773:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103776:	83 c3 01             	add    $0x1,%ebx
80103779:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010377c:	74 0e                	je     8010378c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010377e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103784:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010378a:	75 d4                	jne    80103760 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010378c:	83 ec 0c             	sub    $0xc,%esp
8010378f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103795:	50                   	push   %eax
80103796:	e8 25 0a 00 00       	call   801041c0 <wakeup>
  release(&p->lock);
8010379b:	89 34 24             	mov    %esi,(%esp)
8010379e:	e8 9d 12 00 00       	call   80104a40 <release>
  return i;
801037a3:	83 c4 10             	add    $0x10,%esp
}
801037a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037a9:	89 d8                	mov    %ebx,%eax
801037ab:	5b                   	pop    %ebx
801037ac:	5e                   	pop    %esi
801037ad:	5f                   	pop    %edi
801037ae:	5d                   	pop    %ebp
801037af:	c3                   	ret    
      release(&p->lock);
801037b0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801037b3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801037b8:	56                   	push   %esi
801037b9:	e8 82 12 00 00       	call   80104a40 <release>
      return -1;
801037be:	83 c4 10             	add    $0x10,%esp
}
801037c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037c4:	89 d8                	mov    %ebx,%eax
801037c6:	5b                   	pop    %ebx
801037c7:	5e                   	pop    %esi
801037c8:	5f                   	pop    %edi
801037c9:	5d                   	pop    %ebp
801037ca:	c3                   	ret    
801037cb:	66 90                	xchg   %ax,%ax
801037cd:	66 90                	xchg   %ax,%ax
801037cf:	90                   	nop

801037d0 <wakeup1>:
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037d0:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
801037d5:	eb 17                	jmp    801037ee <wakeup1+0x1e>
801037d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037de:	66 90                	xchg   %ax,%ax
801037e0:	81 c2 8c 00 00 00    	add    $0x8c,%edx
801037e6:	81 fa 54 50 11 80    	cmp    $0x80115054,%edx
801037ec:	74 20                	je     8010380e <wakeup1+0x3e>
    if(p->state == SLEEPING && p->chan == chan)
801037ee:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
801037f2:	75 ec                	jne    801037e0 <wakeup1+0x10>
801037f4:	39 42 20             	cmp    %eax,0x20(%edx)
801037f7:	75 e7                	jne    801037e0 <wakeup1+0x10>
      p->state = RUNNABLE;
801037f9:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103800:	81 c2 8c 00 00 00    	add    $0x8c,%edx
80103806:	81 fa 54 50 11 80    	cmp    $0x80115054,%edx
8010380c:	75 e0                	jne    801037ee <wakeup1+0x1e>
}
8010380e:	c3                   	ret    
8010380f:	90                   	nop

80103810 <allocproc>:
{
80103810:	55                   	push   %ebp
80103811:	89 e5                	mov    %esp,%ebp
80103813:	56                   	push   %esi
80103814:	89 c6                	mov    %eax,%esi
80103816:	53                   	push   %ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103817:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
  acquire(&ptable.lock);
8010381c:	83 ec 0c             	sub    $0xc,%esp
8010381f:	68 20 2d 11 80       	push   $0x80112d20
80103824:	e8 77 12 00 00       	call   80104aa0 <acquire>
80103829:	83 c4 10             	add    $0x10,%esp
8010382c:	eb 14                	jmp    80103842 <allocproc+0x32>
8010382e:	66 90                	xchg   %ax,%ax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103830:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80103836:	81 fb 54 50 11 80    	cmp    $0x80115054,%ebx
8010383c:	0f 84 a6 00 00 00    	je     801038e8 <allocproc+0xd8>
    if(p->state == UNUSED)
80103842:	8b 43 0c             	mov    0xc(%ebx),%eax
80103845:	85 c0                	test   %eax,%eax
80103847:	75 e7                	jne    80103830 <allocproc+0x20>
  p->state = EMBRYO;
80103849:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->mthread = p;
80103850:	89 9b 84 00 00 00    	mov    %ebx,0x84(%ebx)
  p->tno = 1;
80103856:	c7 43 7c 01 00 00 00 	movl   $0x1,0x7c(%ebx)
  if (creator){
8010385d:	85 f6                	test   %esi,%esi
8010385f:	74 6f                	je     801038d0 <allocproc+0xc0>
    p->pid = creator->pid;
80103861:	8b 46 10             	mov    0x10(%esi),%eax
80103864:	89 43 10             	mov    %eax,0x10(%ebx)
    p->tid = creator->tno + 1;
80103867:	8b 46 7c             	mov    0x7c(%esi),%eax
8010386a:	83 c0 01             	add    $0x1,%eax
8010386d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
  release(&ptable.lock);
80103873:	83 ec 0c             	sub    $0xc,%esp
80103876:	68 20 2d 11 80       	push   $0x80112d20
8010387b:	e8 c0 11 00 00       	call   80104a40 <release>
  if((p->kstack = kalloc()) == 0){
80103880:	e8 1b ee ff ff       	call   801026a0 <kalloc>
80103885:	83 c4 10             	add    $0x10,%esp
80103888:	89 43 08             	mov    %eax,0x8(%ebx)
8010388b:	85 c0                	test   %eax,%eax
8010388d:	74 74                	je     80103903 <allocproc+0xf3>
  sp -= sizeof *p->tf;
8010388f:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  memset(p->context, 0, sizeof *p->context);
80103895:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103898:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010389d:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801038a0:	c7 40 14 d7 5e 10 80 	movl   $0x80105ed7,0x14(%eax)
  p->context = (struct context*)sp;
801038a7:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801038aa:	6a 14                	push   $0x14
801038ac:	6a 00                	push   $0x0
801038ae:	50                   	push   %eax
801038af:	e8 ac 12 00 00       	call   80104b60 <memset>
  p->context->eip = (uint)forkret;
801038b4:	8b 43 1c             	mov    0x1c(%ebx),%eax
  return p;
801038b7:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801038ba:	c7 40 10 20 39 10 80 	movl   $0x80103920,0x10(%eax)
}
801038c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038c4:	89 d8                	mov    %ebx,%eax
801038c6:	5b                   	pop    %ebx
801038c7:	5e                   	pop    %esi
801038c8:	5d                   	pop    %ebp
801038c9:	c3                   	ret    
801038ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    p->pid = nextpid++;
801038d0:	a1 04 b0 10 80       	mov    0x8010b004,%eax
801038d5:	8d 50 01             	lea    0x1(%eax),%edx
801038d8:	89 43 10             	mov    %eax,0x10(%ebx)
801038db:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
801038e1:	eb 90                	jmp    80103873 <allocproc+0x63>
801038e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801038e7:	90                   	nop
  release(&ptable.lock);
801038e8:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801038eb:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801038ed:	68 20 2d 11 80       	push   $0x80112d20
801038f2:	e8 49 11 00 00       	call   80104a40 <release>
  return 0;
801038f7:	83 c4 10             	add    $0x10,%esp
}
801038fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038fd:	89 d8                	mov    %ebx,%eax
801038ff:	5b                   	pop    %ebx
80103900:	5e                   	pop    %esi
80103901:	5d                   	pop    %ebp
80103902:	c3                   	ret    
    p->state = UNUSED;
80103903:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
}
8010390a:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
8010390d:	31 db                	xor    %ebx,%ebx
}
8010390f:	89 d8                	mov    %ebx,%eax
80103911:	5b                   	pop    %ebx
80103912:	5e                   	pop    %esi
80103913:	5d                   	pop    %ebp
80103914:	c3                   	ret    
80103915:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010391c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103920 <forkret>:
{
80103920:	55                   	push   %ebp
80103921:	89 e5                	mov    %esp,%ebp
80103923:	83 ec 14             	sub    $0x14,%esp
  release(&ptable.lock);
80103926:	68 20 2d 11 80       	push   $0x80112d20
8010392b:	e8 10 11 00 00       	call   80104a40 <release>
  if (first) {
80103930:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103935:	83 c4 10             	add    $0x10,%esp
80103938:	85 c0                	test   %eax,%eax
8010393a:	75 04                	jne    80103940 <forkret+0x20>
}
8010393c:	c9                   	leave  
8010393d:	c3                   	ret    
8010393e:	66 90                	xchg   %ax,%ax
    first = 0;
80103940:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103947:	00 00 00 
    iinit(ROOTDEV);
8010394a:	83 ec 0c             	sub    $0xc,%esp
8010394d:	6a 01                	push   $0x1
8010394f:	e8 2c dc ff ff       	call   80101580 <iinit>
    initlog(ROOTDEV);
80103954:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010395b:	e8 80 f3 ff ff       	call   80102ce0 <initlog>
}
80103960:	83 c4 10             	add    $0x10,%esp
80103963:	c9                   	leave  
80103964:	c3                   	ret    
80103965:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010396c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103970 <pinit>:
{
80103970:	55                   	push   %ebp
80103971:	89 e5                	mov    %esp,%ebp
80103973:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103976:	68 e0 7d 10 80       	push   $0x80107de0
8010397b:	68 20 2d 11 80       	push   $0x80112d20
80103980:	e8 4b 0f 00 00       	call   801048d0 <initlock>
}
80103985:	83 c4 10             	add    $0x10,%esp
80103988:	c9                   	leave  
80103989:	c3                   	ret    
8010398a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103990 <mycpu>:
{
80103990:	55                   	push   %ebp
80103991:	89 e5                	mov    %esp,%ebp
80103993:	56                   	push   %esi
80103994:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103995:	9c                   	pushf  
80103996:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103997:	f6 c4 02             	test   $0x2,%ah
8010399a:	75 46                	jne    801039e2 <mycpu+0x52>
  apicid = lapicid();
8010399c:	e8 6f ef ff ff       	call   80102910 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801039a1:	8b 35 84 27 11 80    	mov    0x80112784,%esi
801039a7:	85 f6                	test   %esi,%esi
801039a9:	7e 2a                	jle    801039d5 <mycpu+0x45>
801039ab:	31 d2                	xor    %edx,%edx
801039ad:	eb 08                	jmp    801039b7 <mycpu+0x27>
801039af:	90                   	nop
801039b0:	83 c2 01             	add    $0x1,%edx
801039b3:	39 f2                	cmp    %esi,%edx
801039b5:	74 1e                	je     801039d5 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
801039b7:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
801039bd:	0f b6 99 a0 27 11 80 	movzbl -0x7feed860(%ecx),%ebx
801039c4:	39 c3                	cmp    %eax,%ebx
801039c6:	75 e8                	jne    801039b0 <mycpu+0x20>
}
801039c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
801039cb:	8d 81 a0 27 11 80    	lea    -0x7feed860(%ecx),%eax
}
801039d1:	5b                   	pop    %ebx
801039d2:	5e                   	pop    %esi
801039d3:	5d                   	pop    %ebp
801039d4:	c3                   	ret    
  panic("unknown apicid\n");
801039d5:	83 ec 0c             	sub    $0xc,%esp
801039d8:	68 e7 7d 10 80       	push   $0x80107de7
801039dd:	e8 9e c9 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
801039e2:	83 ec 0c             	sub    $0xc,%esp
801039e5:	68 c8 7e 10 80       	push   $0x80107ec8
801039ea:	e8 91 c9 ff ff       	call   80100380 <panic>
801039ef:	90                   	nop

801039f0 <cpuid>:
cpuid() {
801039f0:	55                   	push   %ebp
801039f1:	89 e5                	mov    %esp,%ebp
801039f3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801039f6:	e8 95 ff ff ff       	call   80103990 <mycpu>
}
801039fb:	c9                   	leave  
  return mycpu()-cpus;
801039fc:	2d a0 27 11 80       	sub    $0x801127a0,%eax
80103a01:	c1 f8 04             	sar    $0x4,%eax
80103a04:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103a0a:	c3                   	ret    
80103a0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a0f:	90                   	nop

80103a10 <myproc>:
myproc(void) {
80103a10:	55                   	push   %ebp
80103a11:	89 e5                	mov    %esp,%ebp
80103a13:	53                   	push   %ebx
80103a14:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103a17:	e8 34 0f 00 00       	call   80104950 <pushcli>
  c = mycpu();
80103a1c:	e8 6f ff ff ff       	call   80103990 <mycpu>
  p = c->proc;
80103a21:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a27:	e8 74 0f 00 00       	call   801049a0 <popcli>
}
80103a2c:	89 d8                	mov    %ebx,%eax
80103a2e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a31:	c9                   	leave  
80103a32:	c3                   	ret    
80103a33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a40 <userinit>:
{
80103a40:	55                   	push   %ebp
  p = allocproc(0);
80103a41:	31 c0                	xor    %eax,%eax
{
80103a43:	89 e5                	mov    %esp,%ebp
80103a45:	53                   	push   %ebx
80103a46:	83 ec 04             	sub    $0x4,%esp
  p = allocproc(0);
80103a49:	e8 c2 fd ff ff       	call   80103810 <allocproc>
80103a4e:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103a50:	a3 54 50 11 80       	mov    %eax,0x80115054
  if((p->pgdir = setupkvm()) == 0)
80103a55:	e8 e6 3a 00 00       	call   80107540 <setupkvm>
80103a5a:	89 43 04             	mov    %eax,0x4(%ebx)
80103a5d:	85 c0                	test   %eax,%eax
80103a5f:	0f 84 bd 00 00 00    	je     80103b22 <userinit+0xe2>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103a65:	83 ec 04             	sub    $0x4,%esp
80103a68:	68 2c 00 00 00       	push   $0x2c
80103a6d:	68 60 b4 10 80       	push   $0x8010b460
80103a72:	50                   	push   %eax
80103a73:	e8 78 37 00 00       	call   801071f0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103a78:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103a7b:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103a81:	6a 4c                	push   $0x4c
80103a83:	6a 00                	push   $0x0
80103a85:	ff 73 18             	push   0x18(%ebx)
80103a88:	e8 d3 10 00 00       	call   80104b60 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a8d:	8b 43 18             	mov    0x18(%ebx),%eax
80103a90:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a95:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a98:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a9d:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103aa1:	8b 43 18             	mov    0x18(%ebx),%eax
80103aa4:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103aa8:	8b 43 18             	mov    0x18(%ebx),%eax
80103aab:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103aaf:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103ab3:	8b 43 18             	mov    0x18(%ebx),%eax
80103ab6:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103aba:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103abe:	8b 43 18             	mov    0x18(%ebx),%eax
80103ac1:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103ac8:	8b 43 18             	mov    0x18(%ebx),%eax
80103acb:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103ad2:	8b 43 18             	mov    0x18(%ebx),%eax
80103ad5:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103adc:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103adf:	6a 10                	push   $0x10
80103ae1:	68 10 7e 10 80       	push   $0x80107e10
80103ae6:	50                   	push   %eax
80103ae7:	e8 34 12 00 00       	call   80104d20 <safestrcpy>
  p->cwd = namei("/");
80103aec:	c7 04 24 19 7e 10 80 	movl   $0x80107e19,(%esp)
80103af3:	e8 c8 e5 ff ff       	call   801020c0 <namei>
80103af8:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103afb:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b02:	e8 99 0f 00 00       	call   80104aa0 <acquire>
  p->state = RUNNABLE;
80103b07:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103b0e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b15:	e8 26 0f 00 00       	call   80104a40 <release>
}
80103b1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b1d:	83 c4 10             	add    $0x10,%esp
80103b20:	c9                   	leave  
80103b21:	c3                   	ret    
    panic("userinit: out of memory?");
80103b22:	83 ec 0c             	sub    $0xc,%esp
80103b25:	68 f7 7d 10 80       	push   $0x80107df7
80103b2a:	e8 51 c8 ff ff       	call   80100380 <panic>
80103b2f:	90                   	nop

80103b30 <growproc>:
{
80103b30:	55                   	push   %ebp
80103b31:	89 e5                	mov    %esp,%ebp
80103b33:	56                   	push   %esi
80103b34:	53                   	push   %ebx
80103b35:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103b38:	e8 13 0e 00 00       	call   80104950 <pushcli>
  c = mycpu();
80103b3d:	e8 4e fe ff ff       	call   80103990 <mycpu>
  p = c->proc;
80103b42:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b48:	e8 53 0e 00 00       	call   801049a0 <popcli>
  sz = curproc->mthread->sz;
80103b4d:	8b 93 84 00 00 00    	mov    0x84(%ebx),%edx
80103b53:	8b 02                	mov    (%edx),%eax
  if(n > 0){
80103b55:	85 f6                	test   %esi,%esi
80103b57:	7f 1f                	jg     80103b78 <growproc+0x48>
  } else if(n < 0){
80103b59:	75 45                	jne    80103ba0 <growproc+0x70>
  switchuvm(curproc);
80103b5b:	83 ec 0c             	sub    $0xc,%esp
  curproc->mthread->sz = sz;
80103b5e:	89 02                	mov    %eax,(%edx)
  switchuvm(curproc);
80103b60:	53                   	push   %ebx
80103b61:	e8 7a 35 00 00       	call   801070e0 <switchuvm>
  return 0;
80103b66:	83 c4 10             	add    $0x10,%esp
80103b69:	31 c0                	xor    %eax,%eax
}
80103b6b:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b6e:	5b                   	pop    %ebx
80103b6f:	5e                   	pop    %esi
80103b70:	5d                   	pop    %ebp
80103b71:	c3                   	ret    
80103b72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b78:	83 ec 04             	sub    $0x4,%esp
80103b7b:	01 c6                	add    %eax,%esi
80103b7d:	56                   	push   %esi
80103b7e:	50                   	push   %eax
80103b7f:	ff 73 04             	push   0x4(%ebx)
80103b82:	e8 d9 37 00 00       	call   80107360 <allocuvm>
80103b87:	83 c4 10             	add    $0x10,%esp
80103b8a:	85 c0                	test   %eax,%eax
80103b8c:	74 28                	je     80103bb6 <growproc+0x86>
  curproc->mthread->sz = sz;
80103b8e:	8b 93 84 00 00 00    	mov    0x84(%ebx),%edx
80103b94:	eb c5                	jmp    80103b5b <growproc+0x2b>
80103b96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b9d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ba0:	83 ec 04             	sub    $0x4,%esp
80103ba3:	01 c6                	add    %eax,%esi
80103ba5:	56                   	push   %esi
80103ba6:	50                   	push   %eax
80103ba7:	ff 73 04             	push   0x4(%ebx)
80103baa:	e8 e1 38 00 00       	call   80107490 <deallocuvm>
80103baf:	83 c4 10             	add    $0x10,%esp
80103bb2:	85 c0                	test   %eax,%eax
80103bb4:	75 d8                	jne    80103b8e <growproc+0x5e>
      return -1;
80103bb6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103bbb:	eb ae                	jmp    80103b6b <growproc+0x3b>
80103bbd:	8d 76 00             	lea    0x0(%esi),%esi

80103bc0 <fork>:
{
80103bc0:	55                   	push   %ebp
80103bc1:	89 e5                	mov    %esp,%ebp
80103bc3:	57                   	push   %edi
80103bc4:	56                   	push   %esi
80103bc5:	53                   	push   %ebx
80103bc6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103bc9:	e8 82 0d 00 00       	call   80104950 <pushcli>
  c = mycpu();
80103bce:	e8 bd fd ff ff       	call   80103990 <mycpu>
  p = c->proc;
80103bd3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103bd9:	e8 c2 0d 00 00       	call   801049a0 <popcli>
  if((np = allocproc(0)) == 0){
80103bde:	31 c0                	xor    %eax,%eax
80103be0:	e8 2b fc ff ff       	call   80103810 <allocproc>
80103be5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103be8:	85 c0                	test   %eax,%eax
80103bea:	0f 84 c5 00 00 00    	je     80103cb5 <fork+0xf5>
80103bf0:	89 c7                	mov    %eax,%edi
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->mthread->sz)) == 0){
80103bf2:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
80103bf8:	83 ec 08             	sub    $0x8,%esp
80103bfb:	ff 30                	push   (%eax)
80103bfd:	ff 73 04             	push   0x4(%ebx)
80103c00:	e8 2b 3a 00 00       	call   80107630 <copyuvm>
80103c05:	83 c4 10             	add    $0x10,%esp
80103c08:	89 47 04             	mov    %eax,0x4(%edi)
80103c0b:	85 c0                	test   %eax,%eax
80103c0d:	0f 84 a9 00 00 00    	je     80103cbc <fork+0xfc>
  np->sz = curproc->mthread->sz;
80103c13:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
80103c19:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103c1c:	8b 00                	mov    (%eax),%eax
  *np->tf = *curproc->tf;
80103c1e:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103c21:	89 59 14             	mov    %ebx,0x14(%ecx)
  np->sz = curproc->mthread->sz;
80103c24:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103c26:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103c28:	8b 73 18             	mov    0x18(%ebx),%esi
80103c2b:	b9 13 00 00 00       	mov    $0x13,%ecx
80103c30:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103c32:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103c34:	8b 40 18             	mov    0x18(%eax),%eax
80103c37:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103c3e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[i])
80103c40:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103c44:	85 c0                	test   %eax,%eax
80103c46:	74 13                	je     80103c5b <fork+0x9b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103c48:	83 ec 0c             	sub    $0xc,%esp
80103c4b:	50                   	push   %eax
80103c4c:	e8 6f d2 ff ff       	call   80100ec0 <filedup>
80103c51:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103c54:	83 c4 10             	add    $0x10,%esp
80103c57:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103c5b:	83 c6 01             	add    $0x1,%esi
80103c5e:	83 fe 10             	cmp    $0x10,%esi
80103c61:	75 dd                	jne    80103c40 <fork+0x80>
  np->cwd = idup(curproc->cwd);
80103c63:	83 ec 0c             	sub    $0xc,%esp
80103c66:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c69:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103c6c:	e8 ff da ff ff       	call   80101770 <idup>
80103c71:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c74:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103c77:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c7a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103c7d:	6a 10                	push   $0x10
80103c7f:	53                   	push   %ebx
80103c80:	50                   	push   %eax
80103c81:	e8 9a 10 00 00       	call   80104d20 <safestrcpy>
  pid = np->pid;
80103c86:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103c89:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c90:	e8 0b 0e 00 00       	call   80104aa0 <acquire>
  np->state = RUNNABLE;
80103c95:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103c9c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ca3:	e8 98 0d 00 00       	call   80104a40 <release>
  return pid;
80103ca8:	83 c4 10             	add    $0x10,%esp
}
80103cab:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103cae:	89 d8                	mov    %ebx,%eax
80103cb0:	5b                   	pop    %ebx
80103cb1:	5e                   	pop    %esi
80103cb2:	5f                   	pop    %edi
80103cb3:	5d                   	pop    %ebp
80103cb4:	c3                   	ret    
    return -1;
80103cb5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103cba:	eb ef                	jmp    80103cab <fork+0xeb>
    kfree(np->kstack);
80103cbc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103cbf:	83 ec 0c             	sub    $0xc,%esp
80103cc2:	ff 73 08             	push   0x8(%ebx)
80103cc5:	e8 16 e8 ff ff       	call   801024e0 <kfree>
    np->kstack = 0;
80103cca:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103cd1:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103cd4:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103cdb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103ce0:	eb c9                	jmp    80103cab <fork+0xeb>
80103ce2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103cf0 <scheduler>:
{
80103cf0:	55                   	push   %ebp
80103cf1:	89 e5                	mov    %esp,%ebp
80103cf3:	57                   	push   %edi
80103cf4:	56                   	push   %esi
80103cf5:	53                   	push   %ebx
80103cf6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103cf9:	e8 92 fc ff ff       	call   80103990 <mycpu>
  c->proc = 0;
80103cfe:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103d05:	00 00 00 
  struct cpu *c = mycpu();
80103d08:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103d0a:	8d 78 04             	lea    0x4(%eax),%edi
80103d0d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103d10:	fb                   	sti    
    acquire(&ptable.lock);
80103d11:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d14:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
80103d19:	68 20 2d 11 80       	push   $0x80112d20
80103d1e:	e8 7d 0d 00 00       	call   80104aa0 <acquire>
80103d23:	83 c4 10             	add    $0x10,%esp
80103d26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d2d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103d30:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103d34:	75 33                	jne    80103d69 <scheduler+0x79>
      switchuvm(p);
80103d36:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103d39:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103d3f:	53                   	push   %ebx
80103d40:	e8 9b 33 00 00       	call   801070e0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103d45:	58                   	pop    %eax
80103d46:	5a                   	pop    %edx
80103d47:	ff 73 1c             	push   0x1c(%ebx)
80103d4a:	57                   	push   %edi
      p->state = RUNNING;
80103d4b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103d52:	e8 24 10 00 00       	call   80104d7b <swtch>
      switchkvm();
80103d57:	e8 74 33 00 00       	call   801070d0 <switchkvm>
      c->proc = 0;
80103d5c:	83 c4 10             	add    $0x10,%esp
80103d5f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103d66:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d69:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80103d6f:	81 fb 54 50 11 80    	cmp    $0x80115054,%ebx
80103d75:	75 b9                	jne    80103d30 <scheduler+0x40>
    release(&ptable.lock);
80103d77:	83 ec 0c             	sub    $0xc,%esp
80103d7a:	68 20 2d 11 80       	push   $0x80112d20
80103d7f:	e8 bc 0c 00 00       	call   80104a40 <release>
    sti();
80103d84:	83 c4 10             	add    $0x10,%esp
80103d87:	eb 87                	jmp    80103d10 <scheduler+0x20>
80103d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103d90 <sched>:
{
80103d90:	55                   	push   %ebp
80103d91:	89 e5                	mov    %esp,%ebp
80103d93:	56                   	push   %esi
80103d94:	53                   	push   %ebx
  pushcli();
80103d95:	e8 b6 0b 00 00       	call   80104950 <pushcli>
  c = mycpu();
80103d9a:	e8 f1 fb ff ff       	call   80103990 <mycpu>
  p = c->proc;
80103d9f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103da5:	e8 f6 0b 00 00       	call   801049a0 <popcli>
  if(!holding(&ptable.lock))
80103daa:	83 ec 0c             	sub    $0xc,%esp
80103dad:	68 20 2d 11 80       	push   $0x80112d20
80103db2:	e8 49 0c 00 00       	call   80104a00 <holding>
80103db7:	83 c4 10             	add    $0x10,%esp
80103dba:	85 c0                	test   %eax,%eax
80103dbc:	74 4f                	je     80103e0d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103dbe:	e8 cd fb ff ff       	call   80103990 <mycpu>
80103dc3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103dca:	75 68                	jne    80103e34 <sched+0xa4>
  if(p->state == RUNNING)
80103dcc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103dd0:	74 55                	je     80103e27 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103dd2:	9c                   	pushf  
80103dd3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103dd4:	f6 c4 02             	test   $0x2,%ah
80103dd7:	75 41                	jne    80103e1a <sched+0x8a>
  intena = mycpu()->intena;
80103dd9:	e8 b2 fb ff ff       	call   80103990 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103dde:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103de1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103de7:	e8 a4 fb ff ff       	call   80103990 <mycpu>
80103dec:	83 ec 08             	sub    $0x8,%esp
80103def:	ff 70 04             	push   0x4(%eax)
80103df2:	53                   	push   %ebx
80103df3:	e8 83 0f 00 00       	call   80104d7b <swtch>
  mycpu()->intena = intena;
80103df8:	e8 93 fb ff ff       	call   80103990 <mycpu>
}
80103dfd:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103e00:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103e06:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e09:	5b                   	pop    %ebx
80103e0a:	5e                   	pop    %esi
80103e0b:	5d                   	pop    %ebp
80103e0c:	c3                   	ret    
    panic("sched ptable.lock");
80103e0d:	83 ec 0c             	sub    $0xc,%esp
80103e10:	68 1b 7e 10 80       	push   $0x80107e1b
80103e15:	e8 66 c5 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103e1a:	83 ec 0c             	sub    $0xc,%esp
80103e1d:	68 47 7e 10 80       	push   $0x80107e47
80103e22:	e8 59 c5 ff ff       	call   80100380 <panic>
    panic("sched running");
80103e27:	83 ec 0c             	sub    $0xc,%esp
80103e2a:	68 39 7e 10 80       	push   $0x80107e39
80103e2f:	e8 4c c5 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103e34:	83 ec 0c             	sub    $0xc,%esp
80103e37:	68 2d 7e 10 80       	push   $0x80107e2d
80103e3c:	e8 3f c5 ff ff       	call   80100380 <panic>
80103e41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e4f:	90                   	nop

80103e50 <exit>:
{
80103e50:	55                   	push   %ebp
80103e51:	89 e5                	mov    %esp,%ebp
80103e53:	57                   	push   %edi
80103e54:	56                   	push   %esi
80103e55:	53                   	push   %ebx
80103e56:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103e59:	e8 b2 fb ff ff       	call   80103a10 <myproc>
  if(curproc == initproc)
80103e5e:	39 05 54 50 11 80    	cmp    %eax,0x80115054
80103e64:	0f 84 d7 00 00 00    	je     80103f41 <exit+0xf1>
80103e6a:	89 c3                	mov    %eax,%ebx
80103e6c:	8d 70 28             	lea    0x28(%eax),%esi
80103e6f:	8d 78 68             	lea    0x68(%eax),%edi
80103e72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103e78:	8b 06                	mov    (%esi),%eax
80103e7a:	85 c0                	test   %eax,%eax
80103e7c:	74 12                	je     80103e90 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103e7e:	83 ec 0c             	sub    $0xc,%esp
80103e81:	50                   	push   %eax
80103e82:	e8 89 d0 ff ff       	call   80100f10 <fileclose>
      curproc->ofile[fd] = 0;
80103e87:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103e8d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103e90:	83 c6 04             	add    $0x4,%esi
80103e93:	39 f7                	cmp    %esi,%edi
80103e95:	75 e1                	jne    80103e78 <exit+0x28>
  begin_op();
80103e97:	e8 e4 ee ff ff       	call   80102d80 <begin_op>
  iput(curproc->cwd);
80103e9c:	83 ec 0c             	sub    $0xc,%esp
80103e9f:	ff 73 68             	push   0x68(%ebx)
80103ea2:	e8 29 da ff ff       	call   801018d0 <iput>
  end_op();
80103ea7:	e8 44 ef ff ff       	call   80102df0 <end_op>
  curproc->cwd = 0;
80103eac:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103eb3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103eba:	e8 e1 0b 00 00       	call   80104aa0 <acquire>
  wakeup1(curproc->parent);
80103ebf:	8b 43 14             	mov    0x14(%ebx),%eax
80103ec2:	e8 09 f9 ff ff       	call   801037d0 <wakeup1>
      p->parent = initproc;
80103ec7:	8b 0d 54 50 11 80    	mov    0x80115054,%ecx
80103ecd:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ed0:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103ed5:	eb 17                	jmp    80103eee <exit+0x9e>
80103ed7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ede:	66 90                	xchg   %ax,%ax
80103ee0:	81 c2 8c 00 00 00    	add    $0x8c,%edx
80103ee6:	81 fa 54 50 11 80    	cmp    $0x80115054,%edx
80103eec:	74 3a                	je     80103f28 <exit+0xd8>
    if(p->parent == curproc){
80103eee:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103ef1:	75 ed                	jne    80103ee0 <exit+0x90>
      if(p->state == ZOMBIE)
80103ef3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103ef7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103efa:	75 e4                	jne    80103ee0 <exit+0x90>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103efc:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103f01:	eb 11                	jmp    80103f14 <exit+0xc4>
80103f03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f07:	90                   	nop
80103f08:	05 8c 00 00 00       	add    $0x8c,%eax
80103f0d:	3d 54 50 11 80       	cmp    $0x80115054,%eax
80103f12:	74 cc                	je     80103ee0 <exit+0x90>
    if(p->state == SLEEPING && p->chan == chan)
80103f14:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f18:	75 ee                	jne    80103f08 <exit+0xb8>
80103f1a:	3b 48 20             	cmp    0x20(%eax),%ecx
80103f1d:	75 e9                	jne    80103f08 <exit+0xb8>
      p->state = RUNNABLE;
80103f1f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103f26:	eb e0                	jmp    80103f08 <exit+0xb8>
  curproc->state = ZOMBIE;
80103f28:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103f2f:	e8 5c fe ff ff       	call   80103d90 <sched>
  panic("zombie exit");
80103f34:	83 ec 0c             	sub    $0xc,%esp
80103f37:	68 68 7e 10 80       	push   $0x80107e68
80103f3c:	e8 3f c4 ff ff       	call   80100380 <panic>
    panic("init exiting");
80103f41:	83 ec 0c             	sub    $0xc,%esp
80103f44:	68 5b 7e 10 80       	push   $0x80107e5b
80103f49:	e8 32 c4 ff ff       	call   80100380 <panic>
80103f4e:	66 90                	xchg   %ax,%ax

80103f50 <wait>:
{
80103f50:	55                   	push   %ebp
80103f51:	89 e5                	mov    %esp,%ebp
80103f53:	56                   	push   %esi
80103f54:	53                   	push   %ebx
  pushcli();
80103f55:	e8 f6 09 00 00       	call   80104950 <pushcli>
  c = mycpu();
80103f5a:	e8 31 fa ff ff       	call   80103990 <mycpu>
  p = c->proc;
80103f5f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103f65:	e8 36 0a 00 00       	call   801049a0 <popcli>
  acquire(&ptable.lock);
80103f6a:	83 ec 0c             	sub    $0xc,%esp
80103f6d:	68 20 2d 11 80       	push   $0x80112d20
80103f72:	e8 29 0b 00 00       	call   80104aa0 <acquire>
80103f77:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103f7a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f7c:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103f81:	eb 13                	jmp    80103f96 <wait+0x46>
80103f83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f87:	90                   	nop
80103f88:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80103f8e:	81 fb 54 50 11 80    	cmp    $0x80115054,%ebx
80103f94:	74 1e                	je     80103fb4 <wait+0x64>
      if(p->parent != curproc)
80103f96:	39 73 14             	cmp    %esi,0x14(%ebx)
80103f99:	75 ed                	jne    80103f88 <wait+0x38>
      if(p->state == ZOMBIE){
80103f9b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103f9f:	74 5f                	je     80104000 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fa1:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
      havekids = 1;
80103fa7:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fac:	81 fb 54 50 11 80    	cmp    $0x80115054,%ebx
80103fb2:	75 e2                	jne    80103f96 <wait+0x46>
    if(!havekids || curproc->killed){
80103fb4:	85 c0                	test   %eax,%eax
80103fb6:	0f 84 cc 00 00 00    	je     80104088 <wait+0x138>
80103fbc:	8b 46 24             	mov    0x24(%esi),%eax
80103fbf:	85 c0                	test   %eax,%eax
80103fc1:	0f 85 c1 00 00 00    	jne    80104088 <wait+0x138>
  pushcli();
80103fc7:	e8 84 09 00 00       	call   80104950 <pushcli>
  c = mycpu();
80103fcc:	e8 bf f9 ff ff       	call   80103990 <mycpu>
  p = c->proc;
80103fd1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103fd7:	e8 c4 09 00 00       	call   801049a0 <popcli>
  if(p == 0)
80103fdc:	85 db                	test   %ebx,%ebx
80103fde:	0f 84 bb 00 00 00    	je     8010409f <wait+0x14f>
  p->chan = chan;
80103fe4:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80103fe7:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103fee:	e8 9d fd ff ff       	call   80103d90 <sched>
  p->chan = 0;
80103ff3:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103ffa:	e9 7b ff ff ff       	jmp    80103f7a <wait+0x2a>
80103fff:	90                   	nop
        kfree(p->kstack);
80104000:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104003:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104006:	ff 73 08             	push   0x8(%ebx)
80104009:	e8 d2 e4 ff ff       	call   801024e0 <kfree>
        if (p->tid == 0 || p->tno == 1)
8010400e:	8b 93 80 00 00 00    	mov    0x80(%ebx),%edx
        p->kstack = 0;
80104014:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        if (p->tid == 0 || p->tno == 1)
8010401b:	83 c4 10             	add    $0x10,%esp
8010401e:	85 d2                	test   %edx,%edx
80104020:	74 56                	je     80104078 <wait+0x128>
80104022:	83 7b 7c 01          	cmpl   $0x1,0x7c(%ebx)
80104026:	74 50                	je     80104078 <wait+0x128>
        release(&ptable.lock);
80104028:	83 ec 0c             	sub    $0xc,%esp
        p->pid = 0;
8010402b:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->tid = 0;
80104032:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80104039:	00 00 00 
        p->parent = 0;
8010403c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104043:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104047:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->mthread = 0;
8010404e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80104055:	00 00 00 
        p->state = UNUSED;
80104058:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010405f:	68 20 2d 11 80       	push   $0x80112d20
80104064:	e8 d7 09 00 00       	call   80104a40 <release>
        return pid;
80104069:	83 c4 10             	add    $0x10,%esp
}
8010406c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010406f:	89 f0                	mov    %esi,%eax
80104071:	5b                   	pop    %ebx
80104072:	5e                   	pop    %esi
80104073:	5d                   	pop    %ebp
80104074:	c3                   	ret    
80104075:	8d 76 00             	lea    0x0(%esi),%esi
          freevm(p->pgdir);
80104078:	83 ec 0c             	sub    $0xc,%esp
8010407b:	ff 73 04             	push   0x4(%ebx)
8010407e:	e8 3d 34 00 00       	call   801074c0 <freevm>
80104083:	83 c4 10             	add    $0x10,%esp
80104086:	eb a0                	jmp    80104028 <wait+0xd8>
      release(&ptable.lock);
80104088:	83 ec 0c             	sub    $0xc,%esp
      return -1;
8010408b:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104090:	68 20 2d 11 80       	push   $0x80112d20
80104095:	e8 a6 09 00 00       	call   80104a40 <release>
      return -1;
8010409a:	83 c4 10             	add    $0x10,%esp
8010409d:	eb cd                	jmp    8010406c <wait+0x11c>
    panic("sleep");
8010409f:	83 ec 0c             	sub    $0xc,%esp
801040a2:	68 74 7e 10 80       	push   $0x80107e74
801040a7:	e8 d4 c2 ff ff       	call   80100380 <panic>
801040ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801040b0 <yield>:
{
801040b0:	55                   	push   %ebp
801040b1:	89 e5                	mov    %esp,%ebp
801040b3:	53                   	push   %ebx
801040b4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801040b7:	68 20 2d 11 80       	push   $0x80112d20
801040bc:	e8 df 09 00 00       	call   80104aa0 <acquire>
  pushcli();
801040c1:	e8 8a 08 00 00       	call   80104950 <pushcli>
  c = mycpu();
801040c6:	e8 c5 f8 ff ff       	call   80103990 <mycpu>
  p = c->proc;
801040cb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040d1:	e8 ca 08 00 00       	call   801049a0 <popcli>
  myproc()->state = RUNNABLE;
801040d6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801040dd:	e8 ae fc ff ff       	call   80103d90 <sched>
  release(&ptable.lock);
801040e2:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801040e9:	e8 52 09 00 00       	call   80104a40 <release>
}
801040ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040f1:	83 c4 10             	add    $0x10,%esp
801040f4:	c9                   	leave  
801040f5:	c3                   	ret    
801040f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040fd:	8d 76 00             	lea    0x0(%esi),%esi

80104100 <sleep>:
{
80104100:	55                   	push   %ebp
80104101:	89 e5                	mov    %esp,%ebp
80104103:	57                   	push   %edi
80104104:	56                   	push   %esi
80104105:	53                   	push   %ebx
80104106:	83 ec 0c             	sub    $0xc,%esp
80104109:	8b 7d 08             	mov    0x8(%ebp),%edi
8010410c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010410f:	e8 3c 08 00 00       	call   80104950 <pushcli>
  c = mycpu();
80104114:	e8 77 f8 ff ff       	call   80103990 <mycpu>
  p = c->proc;
80104119:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010411f:	e8 7c 08 00 00       	call   801049a0 <popcli>
  if(p == 0)
80104124:	85 db                	test   %ebx,%ebx
80104126:	0f 84 87 00 00 00    	je     801041b3 <sleep+0xb3>
  if(lk == 0)
8010412c:	85 f6                	test   %esi,%esi
8010412e:	74 76                	je     801041a6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104130:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80104136:	74 50                	je     80104188 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104138:	83 ec 0c             	sub    $0xc,%esp
8010413b:	68 20 2d 11 80       	push   $0x80112d20
80104140:	e8 5b 09 00 00       	call   80104aa0 <acquire>
    release(lk);
80104145:	89 34 24             	mov    %esi,(%esp)
80104148:	e8 f3 08 00 00       	call   80104a40 <release>
  p->chan = chan;
8010414d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104150:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104157:	e8 34 fc ff ff       	call   80103d90 <sched>
  p->chan = 0;
8010415c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104163:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010416a:	e8 d1 08 00 00       	call   80104a40 <release>
    acquire(lk);
8010416f:	89 75 08             	mov    %esi,0x8(%ebp)
80104172:	83 c4 10             	add    $0x10,%esp
}
80104175:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104178:	5b                   	pop    %ebx
80104179:	5e                   	pop    %esi
8010417a:	5f                   	pop    %edi
8010417b:	5d                   	pop    %ebp
    acquire(lk);
8010417c:	e9 1f 09 00 00       	jmp    80104aa0 <acquire>
80104181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104188:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010418b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104192:	e8 f9 fb ff ff       	call   80103d90 <sched>
  p->chan = 0;
80104197:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010419e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041a1:	5b                   	pop    %ebx
801041a2:	5e                   	pop    %esi
801041a3:	5f                   	pop    %edi
801041a4:	5d                   	pop    %ebp
801041a5:	c3                   	ret    
    panic("sleep without lk");
801041a6:	83 ec 0c             	sub    $0xc,%esp
801041a9:	68 7a 7e 10 80       	push   $0x80107e7a
801041ae:	e8 cd c1 ff ff       	call   80100380 <panic>
    panic("sleep");
801041b3:	83 ec 0c             	sub    $0xc,%esp
801041b6:	68 74 7e 10 80       	push   $0x80107e74
801041bb:	e8 c0 c1 ff ff       	call   80100380 <panic>

801041c0 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801041c0:	55                   	push   %ebp
801041c1:	89 e5                	mov    %esp,%ebp
801041c3:	53                   	push   %ebx
801041c4:	83 ec 10             	sub    $0x10,%esp
801041c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801041ca:	68 20 2d 11 80       	push   $0x80112d20
801041cf:	e8 cc 08 00 00       	call   80104aa0 <acquire>
801041d4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041d7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801041dc:	eb 0e                	jmp    801041ec <wakeup+0x2c>
801041de:	66 90                	xchg   %ax,%ax
801041e0:	05 8c 00 00 00       	add    $0x8c,%eax
801041e5:	3d 54 50 11 80       	cmp    $0x80115054,%eax
801041ea:	74 1e                	je     8010420a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
801041ec:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801041f0:	75 ee                	jne    801041e0 <wakeup+0x20>
801041f2:	3b 58 20             	cmp    0x20(%eax),%ebx
801041f5:	75 e9                	jne    801041e0 <wakeup+0x20>
      p->state = RUNNABLE;
801041f7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041fe:	05 8c 00 00 00       	add    $0x8c,%eax
80104203:	3d 54 50 11 80       	cmp    $0x80115054,%eax
80104208:	75 e2                	jne    801041ec <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
8010420a:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80104211:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104214:	c9                   	leave  
  release(&ptable.lock);
80104215:	e9 26 08 00 00       	jmp    80104a40 <release>
8010421a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104220 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	56                   	push   %esi
  struct proc *p;
  int found = 0;
80104224:	31 f6                	xor    %esi,%esi
{
80104226:	53                   	push   %ebx
80104227:	8b 5d 08             	mov    0x8(%ebp),%ebx

  acquire(&ptable.lock);
8010422a:	83 ec 0c             	sub    $0xc,%esp
8010422d:	68 20 2d 11 80       	push   $0x80112d20
80104232:	e8 69 08 00 00       	call   80104aa0 <acquire>
80104237:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010423a:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010423f:	eb 13                	jmp    80104254 <kill+0x34>
80104241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104248:	05 8c 00 00 00       	add    $0x8c,%eax
8010424d:	3d 54 50 11 80       	cmp    $0x80115054,%eax
80104252:	74 2a                	je     8010427e <kill+0x5e>
    if(p->pid == pid){
80104254:	39 58 10             	cmp    %ebx,0x10(%eax)
80104257:	75 ef                	jne    80104248 <kill+0x28>
      found = 1;
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104259:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
8010425d:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      found = 1;
80104264:	be 01 00 00 00       	mov    $0x1,%esi
      if(p->state == SLEEPING)
80104269:	75 dd                	jne    80104248 <kill+0x28>
        p->state = RUNNABLE;
8010426b:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104272:	05 8c 00 00 00       	add    $0x8c,%eax
80104277:	3d 54 50 11 80       	cmp    $0x80115054,%eax
8010427c:	75 d6                	jne    80104254 <kill+0x34>
    }
  }
  release(&ptable.lock);
8010427e:	83 ec 0c             	sub    $0xc,%esp
80104281:	68 20 2d 11 80       	push   $0x80112d20
80104286:	e8 b5 07 00 00       	call   80104a40 <release>
  if (found) return 0;
  return -1;
}
8010428b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  if (found) return 0;
8010428e:	8d 46 ff             	lea    -0x1(%esi),%eax
}
80104291:	5b                   	pop    %ebx
80104292:	5e                   	pop    %esi
80104293:	5d                   	pop    %ebp
80104294:	c3                   	ret    
80104295:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010429c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801042a0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801042a0:	55                   	push   %ebp
801042a1:	89 e5                	mov    %esp,%ebp
801042a3:	57                   	push   %edi
801042a4:	56                   	push   %esi
801042a5:	8d 75 e8             	lea    -0x18(%ebp),%esi
801042a8:	53                   	push   %ebx
801042a9:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
801042ae:	83 ec 3c             	sub    $0x3c,%esp
801042b1:	eb 27                	jmp    801042da <procdump+0x3a>
801042b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042b7:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801042b8:	83 ec 0c             	sub    $0xc,%esp
801042bb:	68 03 82 10 80       	push   $0x80108203
801042c0:	e8 db c3 ff ff       	call   801006a0 <cprintf>
801042c5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042c8:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
801042ce:	81 fb c0 50 11 80    	cmp    $0x801150c0,%ebx
801042d4:	0f 84 96 00 00 00    	je     80104370 <procdump+0xd0>
    if(p->state == UNUSED)
801042da:	8b 43 a0             	mov    -0x60(%ebx),%eax
801042dd:	85 c0                	test   %eax,%eax
801042df:	74 e7                	je     801042c8 <procdump+0x28>
      state = "???";
801042e1:	ba 8b 7e 10 80       	mov    $0x80107e8b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801042e6:	83 f8 05             	cmp    $0x5,%eax
801042e9:	77 11                	ja     801042fc <procdump+0x5c>
801042eb:	8b 14 85 f0 7e 10 80 	mov    -0x7fef8110(,%eax,4),%edx
      state = "???";
801042f2:	b8 8b 7e 10 80       	mov    $0x80107e8b,%eax
801042f7:	85 d2                	test   %edx,%edx
801042f9:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d(%d) %s %s", p->pid, p->tid, state, p->name);
801042fc:	83 ec 0c             	sub    $0xc,%esp
801042ff:	53                   	push   %ebx
80104300:	52                   	push   %edx
80104301:	ff 73 14             	push   0x14(%ebx)
80104304:	ff 73 a4             	push   -0x5c(%ebx)
80104307:	68 8f 7e 10 80       	push   $0x80107e8f
8010430c:	e8 8f c3 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
80104311:	83 c4 20             	add    $0x20,%esp
80104314:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104318:	75 9e                	jne    801042b8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
8010431a:	83 ec 08             	sub    $0x8,%esp
8010431d:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104320:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104323:	50                   	push   %eax
80104324:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104327:	8b 40 0c             	mov    0xc(%eax),%eax
8010432a:	83 c0 08             	add    $0x8,%eax
8010432d:	50                   	push   %eax
8010432e:	e8 bd 05 00 00       	call   801048f0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104333:	83 c4 10             	add    $0x10,%esp
80104336:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010433d:	8d 76 00             	lea    0x0(%esi),%esi
80104340:	8b 17                	mov    (%edi),%edx
80104342:	85 d2                	test   %edx,%edx
80104344:	0f 84 6e ff ff ff    	je     801042b8 <procdump+0x18>
        cprintf(" %p", pc[i]);
8010434a:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
8010434d:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
80104350:	52                   	push   %edx
80104351:	68 e1 78 10 80       	push   $0x801078e1
80104356:	e8 45 c3 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
8010435b:	83 c4 10             	add    $0x10,%esp
8010435e:	39 fe                	cmp    %edi,%esi
80104360:	75 de                	jne    80104340 <procdump+0xa0>
80104362:	e9 51 ff ff ff       	jmp    801042b8 <procdump+0x18>
80104367:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010436e:	66 90                	xchg   %ax,%ax
  }
}
80104370:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104373:	5b                   	pop    %ebx
80104374:	5e                   	pop    %esi
80104375:	5f                   	pop    %edi
80104376:	5d                   	pop    %ebp
80104377:	c3                   	ret    
80104378:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010437f:	90                   	nop

80104380 <thread_create>:
// Sets up stack to return as if from system call.
// Caller must set state of the thread to RUNNABLE.
// Return 0 or non-zero on error.
int
thread_create(thread_t *thread, void *(*start_routine)(void *), void *arg)
{
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
80104383:	57                   	push   %edi
80104384:	56                   	push   %esi
80104385:	53                   	push   %ebx
80104386:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80104389:	e8 c2 05 00 00       	call   80104950 <pushcli>
  c = mycpu();
8010438e:	e8 fd f5 ff ff       	call   80103990 <mycpu>
  p = c->proc;
80104393:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104399:	e8 02 06 00 00       	call   801049a0 <popcli>
  uint sz, sp;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate thread.
  if((np = allocproc(curproc)) == 0){
8010439e:	89 d8                	mov    %ebx,%eax
801043a0:	e8 6b f4 ff ff       	call   80103810 <allocproc>
801043a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801043a8:	85 c0                	test   %eax,%eax
801043aa:	0f 84 37 01 00 00    	je     801044e7 <thread_create+0x167>
    return -1;
  }
  acquire(&ptable.lock);
801043b0:	83 ec 0c             	sub    $0xc,%esp
801043b3:	68 20 2d 11 80       	push   $0x80112d20
801043b8:	e8 e3 06 00 00       	call   80104aa0 <acquire>

  if (curproc->tno == 1) 
801043bd:	8b 43 7c             	mov    0x7c(%ebx),%eax
801043c0:	83 c4 10             	add    $0x10,%esp
801043c3:	83 f8 01             	cmp    $0x1,%eax
801043c6:	75 0a                	jne    801043d2 <thread_create+0x52>
    curproc->tid = 1;
801043c8:	c7 83 80 00 00 00 01 	movl   $0x1,0x80(%ebx)
801043cf:	00 00 00 
  curproc->tno = curproc->tno + 1; 
801043d2:	83 c0 01             	add    $0x1,%eax

  // Set up thread state from proc.
  np->pgdir = curproc->pgdir;
801043d5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  *np->tf = *curproc->tf;
801043d8:	b9 13 00 00 00       	mov    $0x13,%ecx
  curproc->tno = curproc->tno + 1; 
801043dd:	89 43 7c             	mov    %eax,0x7c(%ebx)
  np->pgdir = curproc->pgdir;
801043e0:	8b 43 04             	mov    0x4(%ebx),%eax
  *np->tf = *curproc->tf;
801043e3:	8b 7a 18             	mov    0x18(%edx),%edi
  np->pgdir = curproc->pgdir;
801043e6:	89 42 04             	mov    %eax,0x4(%edx)
  *np->tf = *curproc->tf;
801043e9:	8b 73 18             	mov    0x18(%ebx),%esi
801043ec:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->mthread = curproc;
801043ee:	89 9a 84 00 00 00    	mov    %ebx,0x84(%edx)

  for(i = 0; i < NOFILE; i++)
801043f4:	31 f6                	xor    %esi,%esi
801043f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043fd:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[i])
80104400:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80104404:	85 c0                	test   %eax,%eax
80104406:	74 13                	je     8010441b <thread_create+0x9b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104408:	83 ec 0c             	sub    $0xc,%esp
8010440b:	50                   	push   %eax
8010440c:	e8 af ca ff ff       	call   80100ec0 <filedup>
80104411:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104414:	83 c4 10             	add    $0x10,%esp
80104417:	89 44 b1 28          	mov    %eax,0x28(%ecx,%esi,4)
  for(i = 0; i < NOFILE; i++)
8010441b:	83 c6 01             	add    $0x1,%esi
8010441e:	83 fe 10             	cmp    $0x10,%esi
80104421:	75 dd                	jne    80104400 <thread_create+0x80>
  np->cwd = idup(curproc->cwd);
80104423:	83 ec 0c             	sub    $0xc,%esp
80104426:	ff 73 68             	push   0x68(%ebx)
80104429:	e8 42 d3 ff ff       	call   80101770 <idup>
8010442e:	8b 7d e4             	mov    -0x1c(%ebp),%edi

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104431:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80104434:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104437:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010443a:	6a 10                	push   $0x10
8010443c:	50                   	push   %eax
8010443d:	8d 47 6c             	lea    0x6c(%edi),%eax
80104440:	50                   	push   %eax
80104441:	e8 da 08 00 00       	call   80104d20 <safestrcpy>

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(curproc->sz);
80104446:	8b 03                	mov    (%ebx),%eax
  if((sz = allocuvm(np->pgdir, sz, sz + 2*PGSIZE)) == 0)
80104448:	83 c4 0c             	add    $0xc,%esp
  sz = PGROUNDUP(curproc->sz);
8010444b:	05 ff 0f 00 00       	add    $0xfff,%eax
80104450:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(np->pgdir, sz, sz + 2*PGSIZE)) == 0)
80104455:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
8010445b:	52                   	push   %edx
8010445c:	50                   	push   %eax
8010445d:	ff 77 04             	push   0x4(%edi)
80104460:	e8 fb 2e 00 00       	call   80107360 <allocuvm>
80104465:	83 c4 10             	add    $0x10,%esp
80104468:	89 c6                	mov    %eax,%esi
8010446a:	85 c0                	test   %eax,%eax
8010446c:	74 79                	je     801044e7 <thread_create+0x167>
    return -1;
  clearpteu(np->pgdir, (char*)(sz - 2*PGSIZE));
8010446e:	83 ec 08             	sub    $0x8,%esp
80104471:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80104477:	50                   	push   %eax
80104478:	ff 77 04             	push   0x4(%edi)
8010447b:	e8 60 31 00 00       	call   801075e0 <clearpteu>
  sp = sz;
  curproc->sz = sz;
80104480:	89 33                	mov    %esi,(%ebx)
  np->sz = 2 * PGSIZE;

  // Pass thread ID to user program.
  *thread = np->tid;
80104482:	8b 45 08             	mov    0x8(%ebp),%eax
80104485:	8b 97 80 00 00 00    	mov    0x80(%edi),%edx
  np->sz = 2 * PGSIZE;
8010448b:	c7 07 00 20 00 00    	movl   $0x2000,(%edi)
  *thread = np->tid;
80104491:	89 10                	mov    %edx,(%eax)

  // Set up trapframe to start executing start_routine
  // after returning to user space
  sp -= 4;
  if(copyout(np->pgdir, sp, &arg, sizeof(arg)) < 0)
80104493:	8d 45 10             	lea    0x10(%ebp),%eax
80104496:	6a 04                	push   $0x4
80104498:	50                   	push   %eax
  sp -= 4;
80104499:	8d 46 fc             	lea    -0x4(%esi),%eax
  if(copyout(np->pgdir, sp, &arg, sizeof(arg)) < 0)
8010449c:	50                   	push   %eax
8010449d:	ff 77 04             	push   0x4(%edi)
801044a0:	e8 0b 33 00 00       	call   801077b0 <copyout>
801044a5:	83 c4 20             	add    $0x20,%esp
801044a8:	85 c0                	test   %eax,%eax
801044aa:	78 3b                	js     801044e7 <thread_create+0x167>
    return -1;
  sp -= 4;
  np->tf->esp = sp;
801044ac:	8b 47 18             	mov    0x18(%edi),%eax
  sp -= 4;
801044af:	83 ee 08             	sub    $0x8,%esi
  np->tf->eip = (uint)start_routine;
801044b2:	8b 55 0c             	mov    0xc(%ebp),%edx

  switchuvm(curproc);
801044b5:	83 ec 0c             	sub    $0xc,%esp
  sp -= 4;
801044b8:	89 70 44             	mov    %esi,0x44(%eax)
  np->tf->eip = (uint)start_routine;
801044bb:	8b 47 18             	mov    0x18(%edi),%eax
801044be:	89 50 38             	mov    %edx,0x38(%eax)
  switchuvm(curproc);
801044c1:	53                   	push   %ebx
801044c2:	e8 19 2c 00 00       	call   801070e0 <switchuvm>
  np->state = RUNNABLE;
801044c7:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)

  release(&ptable.lock);
801044ce:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801044d5:	e8 66 05 00 00       	call   80104a40 <release>

  return 0;
801044da:	83 c4 10             	add    $0x10,%esp
801044dd:	31 c0                	xor    %eax,%eax
}
801044df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044e2:	5b                   	pop    %ebx
801044e3:	5e                   	pop    %esi
801044e4:	5f                   	pop    %edi
801044e5:	5d                   	pop    %ebp
801044e6:	c3                   	ret    
    return -1;
801044e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044ec:	eb f1                	jmp    801044df <thread_create+0x15f>
801044ee:	66 90                	xchg   %ax,%ax

801044f0 <thread_exit>:

// Exit the current thread and pass the retval.
// Deallocating the resources will be done at thread_join().
void 
thread_exit(void *retval)
{
801044f0:	55                   	push   %ebp
801044f1:	89 e5                	mov    %esp,%ebp
801044f3:	57                   	push   %edi
801044f4:	56                   	push   %esi
801044f5:	53                   	push   %ebx
801044f6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
801044f9:	e8 12 f5 ff ff       	call   80103a10 <myproc>
801044fe:	89 c3                	mov    %eax,%ebx
  struct proc *p;
  int fd;

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104500:	8d 70 28             	lea    0x28(%eax),%esi
80104503:	8d 78 68             	lea    0x68(%eax),%edi
80104506:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010450d:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80104510:	8b 06                	mov    (%esi),%eax
80104512:	85 c0                	test   %eax,%eax
80104514:	74 12                	je     80104528 <thread_exit+0x38>
      fileclose(curproc->ofile[fd]);
80104516:	83 ec 0c             	sub    $0xc,%esp
80104519:	50                   	push   %eax
8010451a:	e8 f1 c9 ff ff       	call   80100f10 <fileclose>
      curproc->ofile[fd] = 0;
8010451f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80104525:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104528:	83 c6 04             	add    $0x4,%esi
8010452b:	39 fe                	cmp    %edi,%esi
8010452d:	75 e1                	jne    80104510 <thread_exit+0x20>
    }
  }

  begin_op();
8010452f:	e8 4c e8 ff ff       	call   80102d80 <begin_op>
  iput(curproc->cwd);
80104534:	83 ec 0c             	sub    $0xc,%esp
80104537:	ff 73 68             	push   0x68(%ebx)
8010453a:	e8 91 d3 ff ff       	call   801018d0 <iput>
  end_op();
8010453f:	e8 ac e8 ff ff       	call   80102df0 <end_op>
  curproc->cwd = 0;
80104544:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)

  acquire(&ptable.lock);
8010454b:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104552:	e8 49 05 00 00       	call   80104aa0 <acquire>

  // Main process might be sleeping in thread_join().
  wakeup1(curproc->mthread);
80104557:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
8010455d:	e8 6e f2 ff ff       	call   801037d0 <wakeup1>
  curproc->mthread->tno = curproc->mthread->tno - 1;
80104562:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
  curproc->retval = retval;

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80104568:	83 c4 10             	add    $0x10,%esp
8010456b:	8b 0d 54 50 11 80    	mov    0x80115054,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104571:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
  curproc->mthread->tno = curproc->mthread->tno - 1;
80104576:	83 68 7c 01          	subl   $0x1,0x7c(%eax)
  curproc->retval = retval;
8010457a:	8b 45 08             	mov    0x8(%ebp),%eax
8010457d:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104583:	eb 11                	jmp    80104596 <thread_exit+0xa6>
80104585:	8d 76 00             	lea    0x0(%esi),%esi
80104588:	81 c2 8c 00 00 00    	add    $0x8c,%edx
8010458e:	81 fa 54 50 11 80    	cmp    $0x80115054,%edx
80104594:	74 3a                	je     801045d0 <thread_exit+0xe0>
    if(p->parent == curproc){
80104596:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104599:	75 ed                	jne    80104588 <thread_exit+0x98>
      if(p->state == ZOMBIE)
8010459b:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
8010459f:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801045a2:	75 e4                	jne    80104588 <thread_exit+0x98>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045a4:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801045a9:	eb 11                	jmp    801045bc <thread_exit+0xcc>
801045ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045af:	90                   	nop
801045b0:	05 8c 00 00 00       	add    $0x8c,%eax
801045b5:	3d 54 50 11 80       	cmp    $0x80115054,%eax
801045ba:	74 cc                	je     80104588 <thread_exit+0x98>
    if(p->state == SLEEPING && p->chan == chan)
801045bc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801045c0:	75 ee                	jne    801045b0 <thread_exit+0xc0>
801045c2:	3b 48 20             	cmp    0x20(%eax),%ecx
801045c5:	75 e9                	jne    801045b0 <thread_exit+0xc0>
      p->state = RUNNABLE;
801045c7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801045ce:	eb e0                	jmp    801045b0 <thread_exit+0xc0>
        wakeup1(initproc);
    }
  }
  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
801045d0:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
801045d7:	e8 b4 f7 ff ff       	call   80103d90 <sched>
  panic("zombie exit");
801045dc:	83 ec 0c             	sub    $0xc,%esp
801045df:	68 68 7e 10 80       	push   $0x80107e68
801045e4:	e8 97 bd ff ff       	call   80100380 <panic>
801045e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801045f0 <thread_join>:
}

// Wait until the given thread exits
// and take back the resources allocated to it.
int thread_join(thread_t thread, void **retval)
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	57                   	push   %edi
801045f4:	56                   	push   %esi
801045f5:	53                   	push   %ebx
801045f6:	83 ec 0c             	sub    $0xc,%esp
801045f9:	8b 7d 08             	mov    0x8(%ebp),%edi
  pushcli();
801045fc:	e8 4f 03 00 00       	call   80104950 <pushcli>
  c = mycpu();
80104601:	e8 8a f3 ff ff       	call   80103990 <mycpu>
  p = c->proc;
80104606:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010460c:	e8 8f 03 00 00       	call   801049a0 <popcli>
  struct proc *p;
  int found;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
80104611:	83 ec 0c             	sub    $0xc,%esp
80104614:	68 20 2d 11 80       	push   $0x80112d20
80104619:	e8 82 04 00 00       	call   80104aa0 <acquire>
8010461e:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for the thread.
    found = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->pid != curproc->pid || p->tid != thread)
80104621:	8b 46 10             	mov    0x10(%esi),%eax
    found = 0;
80104624:	31 d2                	xor    %edx,%edx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104626:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
8010462b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010462f:	90                   	nop
      if(p->pid != curproc->pid || p->tid != thread)
80104630:	39 43 10             	cmp    %eax,0x10(%ebx)
80104633:	75 13                	jne    80104648 <thread_join+0x58>
80104635:	39 bb 80 00 00 00    	cmp    %edi,0x80(%ebx)
8010463b:	75 0b                	jne    80104648 <thread_join+0x58>
        continue;
      found = 1;
      if(p->state == ZOMBIE){
8010463d:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104641:	74 5d                	je     801046a0 <thread_join+0xb0>
      found = 1;
80104643:	ba 01 00 00 00       	mov    $0x1,%edx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104648:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
8010464e:	81 fb 54 50 11 80    	cmp    $0x80115054,%ebx
80104654:	75 da                	jne    80104630 <thread_join+0x40>
        return 0;
      }
    }

    // No point waiting if we don't have any children.
    if(!found || curproc->killed){
80104656:	85 d2                	test   %edx,%edx
80104658:	0f 84 ac 00 00 00    	je     8010470a <thread_join+0x11a>
8010465e:	8b 46 24             	mov    0x24(%esi),%eax
80104661:	85 c0                	test   %eax,%eax
80104663:	0f 85 a1 00 00 00    	jne    8010470a <thread_join+0x11a>
  pushcli();
80104669:	e8 e2 02 00 00       	call   80104950 <pushcli>
  c = mycpu();
8010466e:	e8 1d f3 ff ff       	call   80103990 <mycpu>
  p = c->proc;
80104673:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104679:	e8 22 03 00 00       	call   801049a0 <popcli>
  if(p == 0)
8010467e:	85 db                	test   %ebx,%ebx
80104680:	0f 84 9b 00 00 00    	je     80104721 <thread_join+0x131>
  p->chan = chan;
80104686:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104689:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104690:	e8 fb f6 ff ff       	call   80103d90 <sched>
  p->chan = 0;
80104695:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010469c:	eb 83                	jmp    80104621 <thread_join+0x31>
8010469e:	66 90                	xchg   %ax,%ax
        *retval = p->retval;
801046a0:	8b 93 88 00 00 00    	mov    0x88(%ebx),%edx
801046a6:	8b 45 0c             	mov    0xc(%ebp),%eax
        kfree(p->kstack);
801046a9:	83 ec 0c             	sub    $0xc,%esp
        *retval = p->retval;
801046ac:	89 10                	mov    %edx,(%eax)
        kfree(p->kstack);
801046ae:	ff 73 08             	push   0x8(%ebx)
801046b1:	e8 2a de ff ff       	call   801024e0 <kfree>
        p->kstack = 0;
801046b6:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        p->pid = 0;
801046bd:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->tid = 0;
801046c4:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
801046cb:	00 00 00 
        p->parent = 0;
801046ce:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->mthread = 0;
801046d5:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
801046dc:	00 00 00 
        p->name[0] = 0;
801046df:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801046e3:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801046ea:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801046f1:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801046f8:	e8 43 03 00 00       	call   80104a40 <release>
        return 0;
801046fd:	83 c4 10             	add    $0x10,%esp
80104700:	31 c0                	xor    %eax,%eax
    }

    // Wait for thread to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80104702:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104705:	5b                   	pop    %ebx
80104706:	5e                   	pop    %esi
80104707:	5f                   	pop    %edi
80104708:	5d                   	pop    %ebp
80104709:	c3                   	ret    
      release(&ptable.lock);
8010470a:	83 ec 0c             	sub    $0xc,%esp
8010470d:	68 20 2d 11 80       	push   $0x80112d20
80104712:	e8 29 03 00 00       	call   80104a40 <release>
      return -1;
80104717:	83 c4 10             	add    $0x10,%esp
8010471a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010471f:	eb e1                	jmp    80104702 <thread_join+0x112>
    panic("sleep");
80104721:	83 ec 0c             	sub    $0xc,%esp
80104724:	68 74 7e 10 80       	push   $0x80107e74
80104729:	e8 52 bc ff ff       	call   80100380 <panic>
8010472e:	66 90                	xchg   %ax,%ax

80104730 <merge>:
  }
}

void
merge(struct proc *curproc)
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	53                   	push   %ebx
80104734:	83 ec 10             	sub    $0x10,%esp
80104737:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010473a:	68 20 2d 11 80       	push   $0x80112d20
8010473f:	e8 5c 03 00 00       	call   80104aa0 <acquire>
  if (curproc->tid == 0)
80104744:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
8010474a:	83 c4 10             	add    $0x10,%esp
8010474d:	85 c0                	test   %eax,%eax
8010474f:	74 34                	je     80104785 <merge+0x55>
  curproc->sz = curproc->mthread->sz;
80104751:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
80104757:	8b 00                	mov    (%eax),%eax
80104759:	89 03                	mov    %eax,(%ebx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010475b:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
    if(p == curproc) continue;
80104760:	39 c3                	cmp    %eax,%ebx
80104762:	74 15                	je     80104779 <merge+0x49>
    if(p->pid == curproc->pid){
80104764:	8b 53 10             	mov    0x10(%ebx),%edx
80104767:	39 50 10             	cmp    %edx,0x10(%eax)
8010476a:	75 0d                	jne    80104779 <merge+0x49>
      p->mthread = curproc;
8010476c:	89 98 84 00 00 00    	mov    %ebx,0x84(%eax)
      p->killed = 1;
80104772:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104779:	05 8c 00 00 00       	add    $0x8c,%eax
8010477e:	3d 54 50 11 80       	cmp    $0x80115054,%eax
80104783:	75 db                	jne    80104760 <merge+0x30>
  merge1(curproc);
  release(&ptable.lock);
80104785:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
8010478c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010478f:	c9                   	leave  
  release(&ptable.lock);
80104790:	e9 ab 02 00 00       	jmp    80104a40 <release>
80104795:	66 90                	xchg   %ax,%ax
80104797:	66 90                	xchg   %ax,%ax
80104799:	66 90                	xchg   %ax,%ax
8010479b:	66 90                	xchg   %ax,%ax
8010479d:	66 90                	xchg   %ax,%ax
8010479f:	90                   	nop

801047a0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
801047a3:	53                   	push   %ebx
801047a4:	83 ec 0c             	sub    $0xc,%esp
801047a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801047aa:	68 08 7f 10 80       	push   $0x80107f08
801047af:	8d 43 04             	lea    0x4(%ebx),%eax
801047b2:	50                   	push   %eax
801047b3:	e8 18 01 00 00       	call   801048d0 <initlock>
  lk->name = name;
801047b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801047bb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801047c1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801047c4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801047cb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801047ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047d1:	c9                   	leave  
801047d2:	c3                   	ret    
801047d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047e0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801047e0:	55                   	push   %ebp
801047e1:	89 e5                	mov    %esp,%ebp
801047e3:	56                   	push   %esi
801047e4:	53                   	push   %ebx
801047e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801047e8:	8d 73 04             	lea    0x4(%ebx),%esi
801047eb:	83 ec 0c             	sub    $0xc,%esp
801047ee:	56                   	push   %esi
801047ef:	e8 ac 02 00 00       	call   80104aa0 <acquire>
  while (lk->locked) {
801047f4:	8b 13                	mov    (%ebx),%edx
801047f6:	83 c4 10             	add    $0x10,%esp
801047f9:	85 d2                	test   %edx,%edx
801047fb:	74 16                	je     80104813 <acquiresleep+0x33>
801047fd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104800:	83 ec 08             	sub    $0x8,%esp
80104803:	56                   	push   %esi
80104804:	53                   	push   %ebx
80104805:	e8 f6 f8 ff ff       	call   80104100 <sleep>
  while (lk->locked) {
8010480a:	8b 03                	mov    (%ebx),%eax
8010480c:	83 c4 10             	add    $0x10,%esp
8010480f:	85 c0                	test   %eax,%eax
80104811:	75 ed                	jne    80104800 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104813:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104819:	e8 f2 f1 ff ff       	call   80103a10 <myproc>
8010481e:	8b 40 10             	mov    0x10(%eax),%eax
80104821:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104824:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104827:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010482a:	5b                   	pop    %ebx
8010482b:	5e                   	pop    %esi
8010482c:	5d                   	pop    %ebp
  release(&lk->lk);
8010482d:	e9 0e 02 00 00       	jmp    80104a40 <release>
80104832:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104840 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	56                   	push   %esi
80104844:	53                   	push   %ebx
80104845:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104848:	8d 73 04             	lea    0x4(%ebx),%esi
8010484b:	83 ec 0c             	sub    $0xc,%esp
8010484e:	56                   	push   %esi
8010484f:	e8 4c 02 00 00       	call   80104aa0 <acquire>
  lk->locked = 0;
80104854:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010485a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104861:	89 1c 24             	mov    %ebx,(%esp)
80104864:	e8 57 f9 ff ff       	call   801041c0 <wakeup>
  release(&lk->lk);
80104869:	89 75 08             	mov    %esi,0x8(%ebp)
8010486c:	83 c4 10             	add    $0x10,%esp
}
8010486f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104872:	5b                   	pop    %ebx
80104873:	5e                   	pop    %esi
80104874:	5d                   	pop    %ebp
  release(&lk->lk);
80104875:	e9 c6 01 00 00       	jmp    80104a40 <release>
8010487a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104880 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104880:	55                   	push   %ebp
80104881:	89 e5                	mov    %esp,%ebp
80104883:	57                   	push   %edi
80104884:	31 ff                	xor    %edi,%edi
80104886:	56                   	push   %esi
80104887:	53                   	push   %ebx
80104888:	83 ec 18             	sub    $0x18,%esp
8010488b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010488e:	8d 73 04             	lea    0x4(%ebx),%esi
80104891:	56                   	push   %esi
80104892:	e8 09 02 00 00       	call   80104aa0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104897:	8b 03                	mov    (%ebx),%eax
80104899:	83 c4 10             	add    $0x10,%esp
8010489c:	85 c0                	test   %eax,%eax
8010489e:	75 18                	jne    801048b8 <holdingsleep+0x38>
  release(&lk->lk);
801048a0:	83 ec 0c             	sub    $0xc,%esp
801048a3:	56                   	push   %esi
801048a4:	e8 97 01 00 00       	call   80104a40 <release>
  return r;
}
801048a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048ac:	89 f8                	mov    %edi,%eax
801048ae:	5b                   	pop    %ebx
801048af:	5e                   	pop    %esi
801048b0:	5f                   	pop    %edi
801048b1:	5d                   	pop    %ebp
801048b2:	c3                   	ret    
801048b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048b7:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
801048b8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801048bb:	e8 50 f1 ff ff       	call   80103a10 <myproc>
801048c0:	39 58 10             	cmp    %ebx,0x10(%eax)
801048c3:	0f 94 c0             	sete   %al
801048c6:	0f b6 c0             	movzbl %al,%eax
801048c9:	89 c7                	mov    %eax,%edi
801048cb:	eb d3                	jmp    801048a0 <holdingsleep+0x20>
801048cd:	66 90                	xchg   %ax,%ax
801048cf:	90                   	nop

801048d0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801048d0:	55                   	push   %ebp
801048d1:	89 e5                	mov    %esp,%ebp
801048d3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801048d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801048d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801048df:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801048e2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801048e9:	5d                   	pop    %ebp
801048ea:	c3                   	ret    
801048eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048ef:	90                   	nop

801048f0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801048f0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801048f1:	31 d2                	xor    %edx,%edx
{
801048f3:	89 e5                	mov    %esp,%ebp
801048f5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801048f6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801048f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801048fc:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
801048ff:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104900:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104906:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010490c:	77 1a                	ja     80104928 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010490e:	8b 58 04             	mov    0x4(%eax),%ebx
80104911:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104914:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104917:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104919:	83 fa 0a             	cmp    $0xa,%edx
8010491c:	75 e2                	jne    80104900 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010491e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104921:	c9                   	leave  
80104922:	c3                   	ret    
80104923:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104927:	90                   	nop
  for(; i < 10; i++)
80104928:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010492b:	8d 51 28             	lea    0x28(%ecx),%edx
8010492e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104930:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104936:	83 c0 04             	add    $0x4,%eax
80104939:	39 d0                	cmp    %edx,%eax
8010493b:	75 f3                	jne    80104930 <getcallerpcs+0x40>
}
8010493d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104940:	c9                   	leave  
80104941:	c3                   	ret    
80104942:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104950 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	53                   	push   %ebx
80104954:	83 ec 04             	sub    $0x4,%esp
80104957:	9c                   	pushf  
80104958:	5b                   	pop    %ebx
  asm volatile("cli");
80104959:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010495a:	e8 31 f0 ff ff       	call   80103990 <mycpu>
8010495f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104965:	85 c0                	test   %eax,%eax
80104967:	74 17                	je     80104980 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104969:	e8 22 f0 ff ff       	call   80103990 <mycpu>
8010496e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104975:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104978:	c9                   	leave  
80104979:	c3                   	ret    
8010497a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104980:	e8 0b f0 ff ff       	call   80103990 <mycpu>
80104985:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010498b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104991:	eb d6                	jmp    80104969 <pushcli+0x19>
80104993:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010499a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801049a0 <popcli>:

void
popcli(void)
{
801049a0:	55                   	push   %ebp
801049a1:	89 e5                	mov    %esp,%ebp
801049a3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801049a6:	9c                   	pushf  
801049a7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801049a8:	f6 c4 02             	test   $0x2,%ah
801049ab:	75 35                	jne    801049e2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801049ad:	e8 de ef ff ff       	call   80103990 <mycpu>
801049b2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801049b9:	78 34                	js     801049ef <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801049bb:	e8 d0 ef ff ff       	call   80103990 <mycpu>
801049c0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801049c6:	85 d2                	test   %edx,%edx
801049c8:	74 06                	je     801049d0 <popcli+0x30>
    sti();
}
801049ca:	c9                   	leave  
801049cb:	c3                   	ret    
801049cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801049d0:	e8 bb ef ff ff       	call   80103990 <mycpu>
801049d5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801049db:	85 c0                	test   %eax,%eax
801049dd:	74 eb                	je     801049ca <popcli+0x2a>
  asm volatile("sti");
801049df:	fb                   	sti    
}
801049e0:	c9                   	leave  
801049e1:	c3                   	ret    
    panic("popcli - interruptible");
801049e2:	83 ec 0c             	sub    $0xc,%esp
801049e5:	68 13 7f 10 80       	push   $0x80107f13
801049ea:	e8 91 b9 ff ff       	call   80100380 <panic>
    panic("popcli");
801049ef:	83 ec 0c             	sub    $0xc,%esp
801049f2:	68 2a 7f 10 80       	push   $0x80107f2a
801049f7:	e8 84 b9 ff ff       	call   80100380 <panic>
801049fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a00 <holding>:
{
80104a00:	55                   	push   %ebp
80104a01:	89 e5                	mov    %esp,%ebp
80104a03:	56                   	push   %esi
80104a04:	53                   	push   %ebx
80104a05:	8b 75 08             	mov    0x8(%ebp),%esi
80104a08:	31 db                	xor    %ebx,%ebx
  pushcli();
80104a0a:	e8 41 ff ff ff       	call   80104950 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104a0f:	8b 06                	mov    (%esi),%eax
80104a11:	85 c0                	test   %eax,%eax
80104a13:	75 0b                	jne    80104a20 <holding+0x20>
  popcli();
80104a15:	e8 86 ff ff ff       	call   801049a0 <popcli>
}
80104a1a:	89 d8                	mov    %ebx,%eax
80104a1c:	5b                   	pop    %ebx
80104a1d:	5e                   	pop    %esi
80104a1e:	5d                   	pop    %ebp
80104a1f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104a20:	8b 5e 08             	mov    0x8(%esi),%ebx
80104a23:	e8 68 ef ff ff       	call   80103990 <mycpu>
80104a28:	39 c3                	cmp    %eax,%ebx
80104a2a:	0f 94 c3             	sete   %bl
  popcli();
80104a2d:	e8 6e ff ff ff       	call   801049a0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104a32:	0f b6 db             	movzbl %bl,%ebx
}
80104a35:	89 d8                	mov    %ebx,%eax
80104a37:	5b                   	pop    %ebx
80104a38:	5e                   	pop    %esi
80104a39:	5d                   	pop    %ebp
80104a3a:	c3                   	ret    
80104a3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a3f:	90                   	nop

80104a40 <release>:
{
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
80104a43:	56                   	push   %esi
80104a44:	53                   	push   %ebx
80104a45:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104a48:	e8 03 ff ff ff       	call   80104950 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104a4d:	8b 03                	mov    (%ebx),%eax
80104a4f:	85 c0                	test   %eax,%eax
80104a51:	75 15                	jne    80104a68 <release+0x28>
  popcli();
80104a53:	e8 48 ff ff ff       	call   801049a0 <popcli>
    panic("release");
80104a58:	83 ec 0c             	sub    $0xc,%esp
80104a5b:	68 31 7f 10 80       	push   $0x80107f31
80104a60:	e8 1b b9 ff ff       	call   80100380 <panic>
80104a65:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104a68:	8b 73 08             	mov    0x8(%ebx),%esi
80104a6b:	e8 20 ef ff ff       	call   80103990 <mycpu>
80104a70:	39 c6                	cmp    %eax,%esi
80104a72:	75 df                	jne    80104a53 <release+0x13>
  popcli();
80104a74:	e8 27 ff ff ff       	call   801049a0 <popcli>
  lk->pcs[0] = 0;
80104a79:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104a80:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104a87:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104a8c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104a92:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a95:	5b                   	pop    %ebx
80104a96:	5e                   	pop    %esi
80104a97:	5d                   	pop    %ebp
  popcli();
80104a98:	e9 03 ff ff ff       	jmp    801049a0 <popcli>
80104a9d:	8d 76 00             	lea    0x0(%esi),%esi

80104aa0 <acquire>:
{
80104aa0:	55                   	push   %ebp
80104aa1:	89 e5                	mov    %esp,%ebp
80104aa3:	53                   	push   %ebx
80104aa4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104aa7:	e8 a4 fe ff ff       	call   80104950 <pushcli>
  if(holding(lk))
80104aac:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104aaf:	e8 9c fe ff ff       	call   80104950 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104ab4:	8b 03                	mov    (%ebx),%eax
80104ab6:	85 c0                	test   %eax,%eax
80104ab8:	75 7e                	jne    80104b38 <acquire+0x98>
  popcli();
80104aba:	e8 e1 fe ff ff       	call   801049a0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104abf:	b9 01 00 00 00       	mov    $0x1,%ecx
80104ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104ac8:	8b 55 08             	mov    0x8(%ebp),%edx
80104acb:	89 c8                	mov    %ecx,%eax
80104acd:	f0 87 02             	lock xchg %eax,(%edx)
80104ad0:	85 c0                	test   %eax,%eax
80104ad2:	75 f4                	jne    80104ac8 <acquire+0x28>
  __sync_synchronize();
80104ad4:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104ad9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104adc:	e8 af ee ff ff       	call   80103990 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104ae1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104ae4:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104ae6:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104ae9:	31 c0                	xor    %eax,%eax
80104aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104aef:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104af0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104af6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104afc:	77 1a                	ja     80104b18 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
80104afe:	8b 5a 04             	mov    0x4(%edx),%ebx
80104b01:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104b05:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104b08:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104b0a:	83 f8 0a             	cmp    $0xa,%eax
80104b0d:	75 e1                	jne    80104af0 <acquire+0x50>
}
80104b0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b12:	c9                   	leave  
80104b13:	c3                   	ret    
80104b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104b18:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
80104b1c:	8d 51 34             	lea    0x34(%ecx),%edx
80104b1f:	90                   	nop
    pcs[i] = 0;
80104b20:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104b26:	83 c0 04             	add    $0x4,%eax
80104b29:	39 c2                	cmp    %eax,%edx
80104b2b:	75 f3                	jne    80104b20 <acquire+0x80>
}
80104b2d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b30:	c9                   	leave  
80104b31:	c3                   	ret    
80104b32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104b38:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104b3b:	e8 50 ee ff ff       	call   80103990 <mycpu>
80104b40:	39 c3                	cmp    %eax,%ebx
80104b42:	0f 85 72 ff ff ff    	jne    80104aba <acquire+0x1a>
  popcli();
80104b48:	e8 53 fe ff ff       	call   801049a0 <popcli>
    panic("acquire");
80104b4d:	83 ec 0c             	sub    $0xc,%esp
80104b50:	68 39 7f 10 80       	push   $0x80107f39
80104b55:	e8 26 b8 ff ff       	call   80100380 <panic>
80104b5a:	66 90                	xchg   %ax,%ax
80104b5c:	66 90                	xchg   %ax,%ax
80104b5e:	66 90                	xchg   %ax,%ax

80104b60 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104b60:	55                   	push   %ebp
80104b61:	89 e5                	mov    %esp,%ebp
80104b63:	57                   	push   %edi
80104b64:	8b 55 08             	mov    0x8(%ebp),%edx
80104b67:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104b6a:	53                   	push   %ebx
80104b6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104b6e:	89 d7                	mov    %edx,%edi
80104b70:	09 cf                	or     %ecx,%edi
80104b72:	83 e7 03             	and    $0x3,%edi
80104b75:	75 29                	jne    80104ba0 <memset+0x40>
    c &= 0xFF;
80104b77:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104b7a:	c1 e0 18             	shl    $0x18,%eax
80104b7d:	89 fb                	mov    %edi,%ebx
80104b7f:	c1 e9 02             	shr    $0x2,%ecx
80104b82:	c1 e3 10             	shl    $0x10,%ebx
80104b85:	09 d8                	or     %ebx,%eax
80104b87:	09 f8                	or     %edi,%eax
80104b89:	c1 e7 08             	shl    $0x8,%edi
80104b8c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104b8e:	89 d7                	mov    %edx,%edi
80104b90:	fc                   	cld    
80104b91:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104b93:	5b                   	pop    %ebx
80104b94:	89 d0                	mov    %edx,%eax
80104b96:	5f                   	pop    %edi
80104b97:	5d                   	pop    %ebp
80104b98:	c3                   	ret    
80104b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104ba0:	89 d7                	mov    %edx,%edi
80104ba2:	fc                   	cld    
80104ba3:	f3 aa                	rep stos %al,%es:(%edi)
80104ba5:	5b                   	pop    %ebx
80104ba6:	89 d0                	mov    %edx,%eax
80104ba8:	5f                   	pop    %edi
80104ba9:	5d                   	pop    %ebp
80104baa:	c3                   	ret    
80104bab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104baf:	90                   	nop

80104bb0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	56                   	push   %esi
80104bb4:	8b 75 10             	mov    0x10(%ebp),%esi
80104bb7:	8b 55 08             	mov    0x8(%ebp),%edx
80104bba:	53                   	push   %ebx
80104bbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104bbe:	85 f6                	test   %esi,%esi
80104bc0:	74 2e                	je     80104bf0 <memcmp+0x40>
80104bc2:	01 c6                	add    %eax,%esi
80104bc4:	eb 14                	jmp    80104bda <memcmp+0x2a>
80104bc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bcd:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104bd0:	83 c0 01             	add    $0x1,%eax
80104bd3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104bd6:	39 f0                	cmp    %esi,%eax
80104bd8:	74 16                	je     80104bf0 <memcmp+0x40>
    if(*s1 != *s2)
80104bda:	0f b6 0a             	movzbl (%edx),%ecx
80104bdd:	0f b6 18             	movzbl (%eax),%ebx
80104be0:	38 d9                	cmp    %bl,%cl
80104be2:	74 ec                	je     80104bd0 <memcmp+0x20>
      return *s1 - *s2;
80104be4:	0f b6 c1             	movzbl %cl,%eax
80104be7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104be9:	5b                   	pop    %ebx
80104bea:	5e                   	pop    %esi
80104beb:	5d                   	pop    %ebp
80104bec:	c3                   	ret    
80104bed:	8d 76 00             	lea    0x0(%esi),%esi
80104bf0:	5b                   	pop    %ebx
  return 0;
80104bf1:	31 c0                	xor    %eax,%eax
}
80104bf3:	5e                   	pop    %esi
80104bf4:	5d                   	pop    %ebp
80104bf5:	c3                   	ret    
80104bf6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bfd:	8d 76 00             	lea    0x0(%esi),%esi

80104c00 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104c00:	55                   	push   %ebp
80104c01:	89 e5                	mov    %esp,%ebp
80104c03:	57                   	push   %edi
80104c04:	8b 55 08             	mov    0x8(%ebp),%edx
80104c07:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104c0a:	56                   	push   %esi
80104c0b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104c0e:	39 d6                	cmp    %edx,%esi
80104c10:	73 26                	jae    80104c38 <memmove+0x38>
80104c12:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104c15:	39 fa                	cmp    %edi,%edx
80104c17:	73 1f                	jae    80104c38 <memmove+0x38>
80104c19:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104c1c:	85 c9                	test   %ecx,%ecx
80104c1e:	74 0c                	je     80104c2c <memmove+0x2c>
      *--d = *--s;
80104c20:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104c24:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104c27:	83 e8 01             	sub    $0x1,%eax
80104c2a:	73 f4                	jae    80104c20 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104c2c:	5e                   	pop    %esi
80104c2d:	89 d0                	mov    %edx,%eax
80104c2f:	5f                   	pop    %edi
80104c30:	5d                   	pop    %ebp
80104c31:	c3                   	ret    
80104c32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104c38:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104c3b:	89 d7                	mov    %edx,%edi
80104c3d:	85 c9                	test   %ecx,%ecx
80104c3f:	74 eb                	je     80104c2c <memmove+0x2c>
80104c41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104c48:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104c49:	39 c6                	cmp    %eax,%esi
80104c4b:	75 fb                	jne    80104c48 <memmove+0x48>
}
80104c4d:	5e                   	pop    %esi
80104c4e:	89 d0                	mov    %edx,%eax
80104c50:	5f                   	pop    %edi
80104c51:	5d                   	pop    %ebp
80104c52:	c3                   	ret    
80104c53:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c60 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104c60:	eb 9e                	jmp    80104c00 <memmove>
80104c62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104c70 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	56                   	push   %esi
80104c74:	8b 75 10             	mov    0x10(%ebp),%esi
80104c77:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104c7a:	53                   	push   %ebx
80104c7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
80104c7e:	85 f6                	test   %esi,%esi
80104c80:	74 2e                	je     80104cb0 <strncmp+0x40>
80104c82:	01 d6                	add    %edx,%esi
80104c84:	eb 18                	jmp    80104c9e <strncmp+0x2e>
80104c86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c8d:	8d 76 00             	lea    0x0(%esi),%esi
80104c90:	38 d8                	cmp    %bl,%al
80104c92:	75 14                	jne    80104ca8 <strncmp+0x38>
    n--, p++, q++;
80104c94:	83 c2 01             	add    $0x1,%edx
80104c97:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104c9a:	39 f2                	cmp    %esi,%edx
80104c9c:	74 12                	je     80104cb0 <strncmp+0x40>
80104c9e:	0f b6 01             	movzbl (%ecx),%eax
80104ca1:	0f b6 1a             	movzbl (%edx),%ebx
80104ca4:	84 c0                	test   %al,%al
80104ca6:	75 e8                	jne    80104c90 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104ca8:	29 d8                	sub    %ebx,%eax
}
80104caa:	5b                   	pop    %ebx
80104cab:	5e                   	pop    %esi
80104cac:	5d                   	pop    %ebp
80104cad:	c3                   	ret    
80104cae:	66 90                	xchg   %ax,%ax
80104cb0:	5b                   	pop    %ebx
    return 0;
80104cb1:	31 c0                	xor    %eax,%eax
}
80104cb3:	5e                   	pop    %esi
80104cb4:	5d                   	pop    %ebp
80104cb5:	c3                   	ret    
80104cb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cbd:	8d 76 00             	lea    0x0(%esi),%esi

80104cc0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	57                   	push   %edi
80104cc4:	56                   	push   %esi
80104cc5:	8b 75 08             	mov    0x8(%ebp),%esi
80104cc8:	53                   	push   %ebx
80104cc9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104ccc:	89 f0                	mov    %esi,%eax
80104cce:	eb 15                	jmp    80104ce5 <strncpy+0x25>
80104cd0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104cd4:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104cd7:	83 c0 01             	add    $0x1,%eax
80104cda:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
80104cde:	88 50 ff             	mov    %dl,-0x1(%eax)
80104ce1:	84 d2                	test   %dl,%dl
80104ce3:	74 09                	je     80104cee <strncpy+0x2e>
80104ce5:	89 cb                	mov    %ecx,%ebx
80104ce7:	83 e9 01             	sub    $0x1,%ecx
80104cea:	85 db                	test   %ebx,%ebx
80104cec:	7f e2                	jg     80104cd0 <strncpy+0x10>
    ;
  while(n-- > 0)
80104cee:	89 c2                	mov    %eax,%edx
80104cf0:	85 c9                	test   %ecx,%ecx
80104cf2:	7e 17                	jle    80104d0b <strncpy+0x4b>
80104cf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104cf8:	83 c2 01             	add    $0x1,%edx
80104cfb:	89 c1                	mov    %eax,%ecx
80104cfd:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80104d01:	29 d1                	sub    %edx,%ecx
80104d03:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104d07:	85 c9                	test   %ecx,%ecx
80104d09:	7f ed                	jg     80104cf8 <strncpy+0x38>
  return os;
}
80104d0b:	5b                   	pop    %ebx
80104d0c:	89 f0                	mov    %esi,%eax
80104d0e:	5e                   	pop    %esi
80104d0f:	5f                   	pop    %edi
80104d10:	5d                   	pop    %ebp
80104d11:	c3                   	ret    
80104d12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104d20 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104d20:	55                   	push   %ebp
80104d21:	89 e5                	mov    %esp,%ebp
80104d23:	56                   	push   %esi
80104d24:	8b 55 10             	mov    0x10(%ebp),%edx
80104d27:	8b 75 08             	mov    0x8(%ebp),%esi
80104d2a:	53                   	push   %ebx
80104d2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104d2e:	85 d2                	test   %edx,%edx
80104d30:	7e 25                	jle    80104d57 <safestrcpy+0x37>
80104d32:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104d36:	89 f2                	mov    %esi,%edx
80104d38:	eb 16                	jmp    80104d50 <safestrcpy+0x30>
80104d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104d40:	0f b6 08             	movzbl (%eax),%ecx
80104d43:	83 c0 01             	add    $0x1,%eax
80104d46:	83 c2 01             	add    $0x1,%edx
80104d49:	88 4a ff             	mov    %cl,-0x1(%edx)
80104d4c:	84 c9                	test   %cl,%cl
80104d4e:	74 04                	je     80104d54 <safestrcpy+0x34>
80104d50:	39 d8                	cmp    %ebx,%eax
80104d52:	75 ec                	jne    80104d40 <safestrcpy+0x20>
    ;
  *s = 0;
80104d54:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104d57:	89 f0                	mov    %esi,%eax
80104d59:	5b                   	pop    %ebx
80104d5a:	5e                   	pop    %esi
80104d5b:	5d                   	pop    %ebp
80104d5c:	c3                   	ret    
80104d5d:	8d 76 00             	lea    0x0(%esi),%esi

80104d60 <strlen>:

int
strlen(const char *s)
{
80104d60:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104d61:	31 c0                	xor    %eax,%eax
{
80104d63:	89 e5                	mov    %esp,%ebp
80104d65:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104d68:	80 3a 00             	cmpb   $0x0,(%edx)
80104d6b:	74 0c                	je     80104d79 <strlen+0x19>
80104d6d:	8d 76 00             	lea    0x0(%esi),%esi
80104d70:	83 c0 01             	add    $0x1,%eax
80104d73:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104d77:	75 f7                	jne    80104d70 <strlen+0x10>
    ;
  return n;
}
80104d79:	5d                   	pop    %ebp
80104d7a:	c3                   	ret    

80104d7b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104d7b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104d7f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104d83:	55                   	push   %ebp
  pushl %ebx
80104d84:	53                   	push   %ebx
  pushl %esi
80104d85:	56                   	push   %esi
  pushl %edi
80104d86:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104d87:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104d89:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104d8b:	5f                   	pop    %edi
  popl %esi
80104d8c:	5e                   	pop    %esi
  popl %ebx
80104d8d:	5b                   	pop    %ebx
  popl %ebp
80104d8e:	5d                   	pop    %ebp
  ret
80104d8f:	c3                   	ret    

80104d90 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104d90:	55                   	push   %ebp
80104d91:	89 e5                	mov    %esp,%ebp
80104d93:	53                   	push   %ebx
80104d94:	83 ec 04             	sub    $0x4,%esp
80104d97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104d9a:	e8 71 ec ff ff       	call   80103a10 <myproc>

  if(addr >= curproc->mthread->sz || addr+4 > curproc->mthread->sz)
80104d9f:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80104da5:	8b 00                	mov    (%eax),%eax
80104da7:	39 d8                	cmp    %ebx,%eax
80104da9:	76 15                	jbe    80104dc0 <fetchint+0x30>
80104dab:	8d 53 04             	lea    0x4(%ebx),%edx
80104dae:	39 d0                	cmp    %edx,%eax
80104db0:	72 0e                	jb     80104dc0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104db2:	8b 45 0c             	mov    0xc(%ebp),%eax
80104db5:	8b 13                	mov    (%ebx),%edx
80104db7:	89 10                	mov    %edx,(%eax)
  return 0;
80104db9:	31 c0                	xor    %eax,%eax
}
80104dbb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104dbe:	c9                   	leave  
80104dbf:	c3                   	ret    
    return -1;
80104dc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dc5:	eb f4                	jmp    80104dbb <fetchint+0x2b>
80104dc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dce:	66 90                	xchg   %ax,%ax

80104dd0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	53                   	push   %ebx
80104dd4:	83 ec 04             	sub    $0x4,%esp
80104dd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104dda:	e8 31 ec ff ff       	call   80103a10 <myproc>

  if(addr >= curproc->mthread->sz)
80104ddf:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
80104de5:	39 1a                	cmp    %ebx,(%edx)
80104de7:	76 2f                	jbe    80104e18 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80104de9:	8b 55 0c             	mov    0xc(%ebp),%edx
80104dec:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->mthread->sz;
80104dee:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80104df4:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104df6:	39 d3                	cmp    %edx,%ebx
80104df8:	73 1e                	jae    80104e18 <fetchstr+0x48>
80104dfa:	89 d8                	mov    %ebx,%eax
80104dfc:	eb 09                	jmp    80104e07 <fetchstr+0x37>
80104dfe:	66 90                	xchg   %ax,%ax
80104e00:	83 c0 01             	add    $0x1,%eax
80104e03:	39 c2                	cmp    %eax,%edx
80104e05:	76 11                	jbe    80104e18 <fetchstr+0x48>
    if(*s == 0)
80104e07:	80 38 00             	cmpb   $0x0,(%eax)
80104e0a:	75 f4                	jne    80104e00 <fetchstr+0x30>
      return s - *pp;
80104e0c:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104e0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e11:	c9                   	leave  
80104e12:	c3                   	ret    
80104e13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e17:	90                   	nop
80104e18:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104e1b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e20:	c9                   	leave  
80104e21:	c3                   	ret    
80104e22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104e30 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104e30:	55                   	push   %ebp
80104e31:	89 e5                	mov    %esp,%ebp
80104e33:	56                   	push   %esi
80104e34:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e35:	e8 d6 eb ff ff       	call   80103a10 <myproc>
80104e3a:	8b 55 08             	mov    0x8(%ebp),%edx
80104e3d:	8b 40 18             	mov    0x18(%eax),%eax
80104e40:	8b 40 44             	mov    0x44(%eax),%eax
80104e43:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104e46:	e8 c5 eb ff ff       	call   80103a10 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e4b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->mthread->sz || addr+4 > curproc->mthread->sz)
80104e4e:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80104e54:	8b 00                	mov    (%eax),%eax
80104e56:	39 c6                	cmp    %eax,%esi
80104e58:	73 16                	jae    80104e70 <argint+0x40>
80104e5a:	8d 53 08             	lea    0x8(%ebx),%edx
80104e5d:	39 d0                	cmp    %edx,%eax
80104e5f:	72 0f                	jb     80104e70 <argint+0x40>
  *ip = *(int*)(addr);
80104e61:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e64:	8b 53 04             	mov    0x4(%ebx),%edx
80104e67:	89 10                	mov    %edx,(%eax)
  return 0;
80104e69:	31 c0                	xor    %eax,%eax
}
80104e6b:	5b                   	pop    %ebx
80104e6c:	5e                   	pop    %esi
80104e6d:	5d                   	pop    %ebp
80104e6e:	c3                   	ret    
80104e6f:	90                   	nop
    return -1;
80104e70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e75:	eb f4                	jmp    80104e6b <argint+0x3b>
80104e77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e7e:	66 90                	xchg   %ax,%ax

80104e80 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104e80:	55                   	push   %ebp
80104e81:	89 e5                	mov    %esp,%ebp
80104e83:	57                   	push   %edi
80104e84:	56                   	push   %esi
80104e85:	53                   	push   %ebx
80104e86:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104e89:	e8 82 eb ff ff       	call   80103a10 <myproc>
80104e8e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e90:	e8 7b eb ff ff       	call   80103a10 <myproc>
80104e95:	8b 55 08             	mov    0x8(%ebp),%edx
80104e98:	8b 40 18             	mov    0x18(%eax),%eax
80104e9b:	8b 40 44             	mov    0x44(%eax),%eax
80104e9e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104ea1:	e8 6a eb ff ff       	call   80103a10 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ea6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->mthread->sz || addr+4 > curproc->mthread->sz)
80104ea9:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80104eaf:	8b 00                	mov    (%eax),%eax
80104eb1:	39 c7                	cmp    %eax,%edi
80104eb3:	73 3b                	jae    80104ef0 <argptr+0x70>
80104eb5:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104eb8:	39 c8                	cmp    %ecx,%eax
80104eba:	72 34                	jb     80104ef0 <argptr+0x70>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->mthread->sz || (uint)i+size > curproc->mthread->sz)
80104ebc:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104ebf:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->mthread->sz || (uint)i+size > curproc->mthread->sz)
80104ec2:	85 d2                	test   %edx,%edx
80104ec4:	78 2a                	js     80104ef0 <argptr+0x70>
80104ec6:	8b 96 84 00 00 00    	mov    0x84(%esi),%edx
80104ecc:	8b 12                	mov    (%edx),%edx
80104ece:	39 c2                	cmp    %eax,%edx
80104ed0:	76 1e                	jbe    80104ef0 <argptr+0x70>
80104ed2:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104ed5:	01 c3                	add    %eax,%ebx
80104ed7:	39 da                	cmp    %ebx,%edx
80104ed9:	72 15                	jb     80104ef0 <argptr+0x70>
    return -1;
  *pp = (char*)i;
80104edb:	8b 55 0c             	mov    0xc(%ebp),%edx
80104ede:	89 02                	mov    %eax,(%edx)
  return 0;
80104ee0:	31 c0                	xor    %eax,%eax
}
80104ee2:	83 c4 0c             	add    $0xc,%esp
80104ee5:	5b                   	pop    %ebx
80104ee6:	5e                   	pop    %esi
80104ee7:	5f                   	pop    %edi
80104ee8:	5d                   	pop    %ebp
80104ee9:	c3                   	ret    
80104eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104ef0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ef5:	eb eb                	jmp    80104ee2 <argptr+0x62>
80104ef7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104efe:	66 90                	xchg   %ax,%ax

80104f00 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104f00:	55                   	push   %ebp
80104f01:	89 e5                	mov    %esp,%ebp
80104f03:	56                   	push   %esi
80104f04:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f05:	e8 06 eb ff ff       	call   80103a10 <myproc>
80104f0a:	8b 55 08             	mov    0x8(%ebp),%edx
80104f0d:	8b 40 18             	mov    0x18(%eax),%eax
80104f10:	8b 40 44             	mov    0x44(%eax),%eax
80104f13:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104f16:	e8 f5 ea ff ff       	call   80103a10 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f1b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->mthread->sz || addr+4 > curproc->mthread->sz)
80104f1e:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80104f24:	8b 00                	mov    (%eax),%eax
80104f26:	39 c6                	cmp    %eax,%esi
80104f28:	73 4e                	jae    80104f78 <argstr+0x78>
80104f2a:	8d 53 08             	lea    0x8(%ebx),%edx
80104f2d:	39 d0                	cmp    %edx,%eax
80104f2f:	72 47                	jb     80104f78 <argstr+0x78>
  *ip = *(int*)(addr);
80104f31:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104f34:	e8 d7 ea ff ff       	call   80103a10 <myproc>
  if(addr >= curproc->mthread->sz)
80104f39:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
80104f3f:	3b 1a                	cmp    (%edx),%ebx
80104f41:	73 35                	jae    80104f78 <argstr+0x78>
  *pp = (char*)addr;
80104f43:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f46:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->mthread->sz;
80104f48:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80104f4e:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104f50:	39 d3                	cmp    %edx,%ebx
80104f52:	73 24                	jae    80104f78 <argstr+0x78>
80104f54:	89 d8                	mov    %ebx,%eax
80104f56:	eb 0f                	jmp    80104f67 <argstr+0x67>
80104f58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f5f:	90                   	nop
80104f60:	83 c0 01             	add    $0x1,%eax
80104f63:	39 c2                	cmp    %eax,%edx
80104f65:	76 11                	jbe    80104f78 <argstr+0x78>
    if(*s == 0)
80104f67:	80 38 00             	cmpb   $0x0,(%eax)
80104f6a:	75 f4                	jne    80104f60 <argstr+0x60>
      return s - *pp;
80104f6c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104f6e:	5b                   	pop    %ebx
80104f6f:	5e                   	pop    %esi
80104f70:	5d                   	pop    %ebp
80104f71:	c3                   	ret    
80104f72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f78:	5b                   	pop    %ebx
    return -1;
80104f79:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f7e:	5e                   	pop    %esi
80104f7f:	5d                   	pop    %ebp
80104f80:	c3                   	ret    
80104f81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f8f:	90                   	nop

80104f90 <syscall>:
[SYS_thread_join]    sys_thread_join,
};

void
syscall(void)
{
80104f90:	55                   	push   %ebp
80104f91:	89 e5                	mov    %esp,%ebp
80104f93:	53                   	push   %ebx
80104f94:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104f97:	e8 74 ea ff ff       	call   80103a10 <myproc>
80104f9c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104f9e:	8b 40 18             	mov    0x18(%eax),%eax
80104fa1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104fa4:	8d 50 ff             	lea    -0x1(%eax),%edx
80104fa7:	83 fa 17             	cmp    $0x17,%edx
80104faa:	77 24                	ja     80104fd0 <syscall+0x40>
80104fac:	8b 14 85 60 7f 10 80 	mov    -0x7fef80a0(,%eax,4),%edx
80104fb3:	85 d2                	test   %edx,%edx
80104fb5:	74 19                	je     80104fd0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104fb7:	ff d2                	call   *%edx
80104fb9:	89 c2                	mov    %eax,%edx
80104fbb:	8b 43 18             	mov    0x18(%ebx),%eax
80104fbe:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104fc1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104fc4:	c9                   	leave  
80104fc5:	c3                   	ret    
80104fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fcd:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104fd0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104fd1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104fd4:	50                   	push   %eax
80104fd5:	ff 73 10             	push   0x10(%ebx)
80104fd8:	68 41 7f 10 80       	push   $0x80107f41
80104fdd:	e8 be b6 ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80104fe2:	8b 43 18             	mov    0x18(%ebx),%eax
80104fe5:	83 c4 10             	add    $0x10,%esp
80104fe8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104fef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ff2:	c9                   	leave  
80104ff3:	c3                   	ret    
80104ff4:	66 90                	xchg   %ax,%ax
80104ff6:	66 90                	xchg   %ax,%ax
80104ff8:	66 90                	xchg   %ax,%ax
80104ffa:	66 90                	xchg   %ax,%ax
80104ffc:	66 90                	xchg   %ax,%ax
80104ffe:	66 90                	xchg   %ax,%ax

80105000 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105000:	55                   	push   %ebp
80105001:	89 e5                	mov    %esp,%ebp
80105003:	57                   	push   %edi
80105004:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105005:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105008:	53                   	push   %ebx
80105009:	83 ec 34             	sub    $0x34,%esp
8010500c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010500f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105012:	57                   	push   %edi
80105013:	50                   	push   %eax
{
80105014:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105017:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010501a:	e8 c1 d0 ff ff       	call   801020e0 <nameiparent>
8010501f:	83 c4 10             	add    $0x10,%esp
80105022:	85 c0                	test   %eax,%eax
80105024:	0f 84 46 01 00 00    	je     80105170 <create+0x170>
    return 0;
  ilock(dp);
8010502a:	83 ec 0c             	sub    $0xc,%esp
8010502d:	89 c3                	mov    %eax,%ebx
8010502f:	50                   	push   %eax
80105030:	e8 6b c7 ff ff       	call   801017a0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105035:	83 c4 0c             	add    $0xc,%esp
80105038:	6a 00                	push   $0x0
8010503a:	57                   	push   %edi
8010503b:	53                   	push   %ebx
8010503c:	e8 bf cc ff ff       	call   80101d00 <dirlookup>
80105041:	83 c4 10             	add    $0x10,%esp
80105044:	89 c6                	mov    %eax,%esi
80105046:	85 c0                	test   %eax,%eax
80105048:	74 56                	je     801050a0 <create+0xa0>
    iunlockput(dp);
8010504a:	83 ec 0c             	sub    $0xc,%esp
8010504d:	53                   	push   %ebx
8010504e:	e8 dd c9 ff ff       	call   80101a30 <iunlockput>
    ilock(ip);
80105053:	89 34 24             	mov    %esi,(%esp)
80105056:	e8 45 c7 ff ff       	call   801017a0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010505b:	83 c4 10             	add    $0x10,%esp
8010505e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105063:	75 1b                	jne    80105080 <create+0x80>
80105065:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010506a:	75 14                	jne    80105080 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010506c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010506f:	89 f0                	mov    %esi,%eax
80105071:	5b                   	pop    %ebx
80105072:	5e                   	pop    %esi
80105073:	5f                   	pop    %edi
80105074:	5d                   	pop    %ebp
80105075:	c3                   	ret    
80105076:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010507d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105080:	83 ec 0c             	sub    $0xc,%esp
80105083:	56                   	push   %esi
    return 0;
80105084:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105086:	e8 a5 c9 ff ff       	call   80101a30 <iunlockput>
    return 0;
8010508b:	83 c4 10             	add    $0x10,%esp
}
8010508e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105091:	89 f0                	mov    %esi,%eax
80105093:	5b                   	pop    %ebx
80105094:	5e                   	pop    %esi
80105095:	5f                   	pop    %edi
80105096:	5d                   	pop    %ebp
80105097:	c3                   	ret    
80105098:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010509f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
801050a0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801050a4:	83 ec 08             	sub    $0x8,%esp
801050a7:	50                   	push   %eax
801050a8:	ff 33                	push   (%ebx)
801050aa:	e8 81 c5 ff ff       	call   80101630 <ialloc>
801050af:	83 c4 10             	add    $0x10,%esp
801050b2:	89 c6                	mov    %eax,%esi
801050b4:	85 c0                	test   %eax,%eax
801050b6:	0f 84 cd 00 00 00    	je     80105189 <create+0x189>
  ilock(ip);
801050bc:	83 ec 0c             	sub    $0xc,%esp
801050bf:	50                   	push   %eax
801050c0:	e8 db c6 ff ff       	call   801017a0 <ilock>
  ip->major = major;
801050c5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
801050c9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
801050cd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
801050d1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
801050d5:	b8 01 00 00 00       	mov    $0x1,%eax
801050da:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
801050de:	89 34 24             	mov    %esi,(%esp)
801050e1:	e8 0a c6 ff ff       	call   801016f0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801050e6:	83 c4 10             	add    $0x10,%esp
801050e9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801050ee:	74 30                	je     80105120 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
801050f0:	83 ec 04             	sub    $0x4,%esp
801050f3:	ff 76 04             	push   0x4(%esi)
801050f6:	57                   	push   %edi
801050f7:	53                   	push   %ebx
801050f8:	e8 03 cf ff ff       	call   80102000 <dirlink>
801050fd:	83 c4 10             	add    $0x10,%esp
80105100:	85 c0                	test   %eax,%eax
80105102:	78 78                	js     8010517c <create+0x17c>
  iunlockput(dp);
80105104:	83 ec 0c             	sub    $0xc,%esp
80105107:	53                   	push   %ebx
80105108:	e8 23 c9 ff ff       	call   80101a30 <iunlockput>
  return ip;
8010510d:	83 c4 10             	add    $0x10,%esp
}
80105110:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105113:	89 f0                	mov    %esi,%eax
80105115:	5b                   	pop    %ebx
80105116:	5e                   	pop    %esi
80105117:	5f                   	pop    %edi
80105118:	5d                   	pop    %ebp
80105119:	c3                   	ret    
8010511a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105120:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105123:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105128:	53                   	push   %ebx
80105129:	e8 c2 c5 ff ff       	call   801016f0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010512e:	83 c4 0c             	add    $0xc,%esp
80105131:	ff 76 04             	push   0x4(%esi)
80105134:	68 e0 7f 10 80       	push   $0x80107fe0
80105139:	56                   	push   %esi
8010513a:	e8 c1 ce ff ff       	call   80102000 <dirlink>
8010513f:	83 c4 10             	add    $0x10,%esp
80105142:	85 c0                	test   %eax,%eax
80105144:	78 18                	js     8010515e <create+0x15e>
80105146:	83 ec 04             	sub    $0x4,%esp
80105149:	ff 73 04             	push   0x4(%ebx)
8010514c:	68 df 7f 10 80       	push   $0x80107fdf
80105151:	56                   	push   %esi
80105152:	e8 a9 ce ff ff       	call   80102000 <dirlink>
80105157:	83 c4 10             	add    $0x10,%esp
8010515a:	85 c0                	test   %eax,%eax
8010515c:	79 92                	jns    801050f0 <create+0xf0>
      panic("create dots");
8010515e:	83 ec 0c             	sub    $0xc,%esp
80105161:	68 d3 7f 10 80       	push   $0x80107fd3
80105166:	e8 15 b2 ff ff       	call   80100380 <panic>
8010516b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010516f:	90                   	nop
}
80105170:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105173:	31 f6                	xor    %esi,%esi
}
80105175:	5b                   	pop    %ebx
80105176:	89 f0                	mov    %esi,%eax
80105178:	5e                   	pop    %esi
80105179:	5f                   	pop    %edi
8010517a:	5d                   	pop    %ebp
8010517b:	c3                   	ret    
    panic("create: dirlink");
8010517c:	83 ec 0c             	sub    $0xc,%esp
8010517f:	68 e2 7f 10 80       	push   $0x80107fe2
80105184:	e8 f7 b1 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80105189:	83 ec 0c             	sub    $0xc,%esp
8010518c:	68 c4 7f 10 80       	push   $0x80107fc4
80105191:	e8 ea b1 ff ff       	call   80100380 <panic>
80105196:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010519d:	8d 76 00             	lea    0x0(%esi),%esi

801051a0 <sys_dup>:
{
801051a0:	55                   	push   %ebp
801051a1:	89 e5                	mov    %esp,%ebp
801051a3:	56                   	push   %esi
801051a4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801051a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801051a8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801051ab:	50                   	push   %eax
801051ac:	6a 00                	push   $0x0
801051ae:	e8 7d fc ff ff       	call   80104e30 <argint>
801051b3:	83 c4 10             	add    $0x10,%esp
801051b6:	85 c0                	test   %eax,%eax
801051b8:	78 36                	js     801051f0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801051ba:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801051be:	77 30                	ja     801051f0 <sys_dup+0x50>
801051c0:	e8 4b e8 ff ff       	call   80103a10 <myproc>
801051c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801051c8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801051cc:	85 f6                	test   %esi,%esi
801051ce:	74 20                	je     801051f0 <sys_dup+0x50>
  struct proc *curproc = myproc();
801051d0:	e8 3b e8 ff ff       	call   80103a10 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801051d5:	31 db                	xor    %ebx,%ebx
801051d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051de:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
801051e0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801051e4:	85 d2                	test   %edx,%edx
801051e6:	74 18                	je     80105200 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
801051e8:	83 c3 01             	add    $0x1,%ebx
801051eb:	83 fb 10             	cmp    $0x10,%ebx
801051ee:	75 f0                	jne    801051e0 <sys_dup+0x40>
}
801051f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801051f3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801051f8:	89 d8                	mov    %ebx,%eax
801051fa:	5b                   	pop    %ebx
801051fb:	5e                   	pop    %esi
801051fc:	5d                   	pop    %ebp
801051fd:	c3                   	ret    
801051fe:	66 90                	xchg   %ax,%ax
  filedup(f);
80105200:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105203:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105207:	56                   	push   %esi
80105208:	e8 b3 bc ff ff       	call   80100ec0 <filedup>
  return fd;
8010520d:	83 c4 10             	add    $0x10,%esp
}
80105210:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105213:	89 d8                	mov    %ebx,%eax
80105215:	5b                   	pop    %ebx
80105216:	5e                   	pop    %esi
80105217:	5d                   	pop    %ebp
80105218:	c3                   	ret    
80105219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105220 <sys_read>:
{
80105220:	55                   	push   %ebp
80105221:	89 e5                	mov    %esp,%ebp
80105223:	56                   	push   %esi
80105224:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105225:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105228:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010522b:	53                   	push   %ebx
8010522c:	6a 00                	push   $0x0
8010522e:	e8 fd fb ff ff       	call   80104e30 <argint>
80105233:	83 c4 10             	add    $0x10,%esp
80105236:	85 c0                	test   %eax,%eax
80105238:	78 5e                	js     80105298 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010523a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010523e:	77 58                	ja     80105298 <sys_read+0x78>
80105240:	e8 cb e7 ff ff       	call   80103a10 <myproc>
80105245:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105248:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010524c:	85 f6                	test   %esi,%esi
8010524e:	74 48                	je     80105298 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105250:	83 ec 08             	sub    $0x8,%esp
80105253:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105256:	50                   	push   %eax
80105257:	6a 02                	push   $0x2
80105259:	e8 d2 fb ff ff       	call   80104e30 <argint>
8010525e:	83 c4 10             	add    $0x10,%esp
80105261:	85 c0                	test   %eax,%eax
80105263:	78 33                	js     80105298 <sys_read+0x78>
80105265:	83 ec 04             	sub    $0x4,%esp
80105268:	ff 75 f0             	push   -0x10(%ebp)
8010526b:	53                   	push   %ebx
8010526c:	6a 01                	push   $0x1
8010526e:	e8 0d fc ff ff       	call   80104e80 <argptr>
80105273:	83 c4 10             	add    $0x10,%esp
80105276:	85 c0                	test   %eax,%eax
80105278:	78 1e                	js     80105298 <sys_read+0x78>
  return fileread(f, p, n);
8010527a:	83 ec 04             	sub    $0x4,%esp
8010527d:	ff 75 f0             	push   -0x10(%ebp)
80105280:	ff 75 f4             	push   -0xc(%ebp)
80105283:	56                   	push   %esi
80105284:	e8 b7 bd ff ff       	call   80101040 <fileread>
80105289:	83 c4 10             	add    $0x10,%esp
}
8010528c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010528f:	5b                   	pop    %ebx
80105290:	5e                   	pop    %esi
80105291:	5d                   	pop    %ebp
80105292:	c3                   	ret    
80105293:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105297:	90                   	nop
    return -1;
80105298:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010529d:	eb ed                	jmp    8010528c <sys_read+0x6c>
8010529f:	90                   	nop

801052a0 <sys_write>:
{
801052a0:	55                   	push   %ebp
801052a1:	89 e5                	mov    %esp,%ebp
801052a3:	56                   	push   %esi
801052a4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801052a5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801052a8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801052ab:	53                   	push   %ebx
801052ac:	6a 00                	push   $0x0
801052ae:	e8 7d fb ff ff       	call   80104e30 <argint>
801052b3:	83 c4 10             	add    $0x10,%esp
801052b6:	85 c0                	test   %eax,%eax
801052b8:	78 5e                	js     80105318 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801052ba:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801052be:	77 58                	ja     80105318 <sys_write+0x78>
801052c0:	e8 4b e7 ff ff       	call   80103a10 <myproc>
801052c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801052c8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801052cc:	85 f6                	test   %esi,%esi
801052ce:	74 48                	je     80105318 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801052d0:	83 ec 08             	sub    $0x8,%esp
801052d3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052d6:	50                   	push   %eax
801052d7:	6a 02                	push   $0x2
801052d9:	e8 52 fb ff ff       	call   80104e30 <argint>
801052de:	83 c4 10             	add    $0x10,%esp
801052e1:	85 c0                	test   %eax,%eax
801052e3:	78 33                	js     80105318 <sys_write+0x78>
801052e5:	83 ec 04             	sub    $0x4,%esp
801052e8:	ff 75 f0             	push   -0x10(%ebp)
801052eb:	53                   	push   %ebx
801052ec:	6a 01                	push   $0x1
801052ee:	e8 8d fb ff ff       	call   80104e80 <argptr>
801052f3:	83 c4 10             	add    $0x10,%esp
801052f6:	85 c0                	test   %eax,%eax
801052f8:	78 1e                	js     80105318 <sys_write+0x78>
  return filewrite(f, p, n);
801052fa:	83 ec 04             	sub    $0x4,%esp
801052fd:	ff 75 f0             	push   -0x10(%ebp)
80105300:	ff 75 f4             	push   -0xc(%ebp)
80105303:	56                   	push   %esi
80105304:	e8 c7 bd ff ff       	call   801010d0 <filewrite>
80105309:	83 c4 10             	add    $0x10,%esp
}
8010530c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010530f:	5b                   	pop    %ebx
80105310:	5e                   	pop    %esi
80105311:	5d                   	pop    %ebp
80105312:	c3                   	ret    
80105313:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105317:	90                   	nop
    return -1;
80105318:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010531d:	eb ed                	jmp    8010530c <sys_write+0x6c>
8010531f:	90                   	nop

80105320 <sys_close>:
{
80105320:	55                   	push   %ebp
80105321:	89 e5                	mov    %esp,%ebp
80105323:	56                   	push   %esi
80105324:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105325:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105328:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010532b:	50                   	push   %eax
8010532c:	6a 00                	push   $0x0
8010532e:	e8 fd fa ff ff       	call   80104e30 <argint>
80105333:	83 c4 10             	add    $0x10,%esp
80105336:	85 c0                	test   %eax,%eax
80105338:	78 3e                	js     80105378 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010533a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010533e:	77 38                	ja     80105378 <sys_close+0x58>
80105340:	e8 cb e6 ff ff       	call   80103a10 <myproc>
80105345:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105348:	8d 5a 08             	lea    0x8(%edx),%ebx
8010534b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010534f:	85 f6                	test   %esi,%esi
80105351:	74 25                	je     80105378 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105353:	e8 b8 e6 ff ff       	call   80103a10 <myproc>
  fileclose(f);
80105358:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010535b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105362:	00 
  fileclose(f);
80105363:	56                   	push   %esi
80105364:	e8 a7 bb ff ff       	call   80100f10 <fileclose>
  return 0;
80105369:	83 c4 10             	add    $0x10,%esp
8010536c:	31 c0                	xor    %eax,%eax
}
8010536e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105371:	5b                   	pop    %ebx
80105372:	5e                   	pop    %esi
80105373:	5d                   	pop    %ebp
80105374:	c3                   	ret    
80105375:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105378:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010537d:	eb ef                	jmp    8010536e <sys_close+0x4e>
8010537f:	90                   	nop

80105380 <sys_fstat>:
{
80105380:	55                   	push   %ebp
80105381:	89 e5                	mov    %esp,%ebp
80105383:	56                   	push   %esi
80105384:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105385:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105388:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010538b:	53                   	push   %ebx
8010538c:	6a 00                	push   $0x0
8010538e:	e8 9d fa ff ff       	call   80104e30 <argint>
80105393:	83 c4 10             	add    $0x10,%esp
80105396:	85 c0                	test   %eax,%eax
80105398:	78 46                	js     801053e0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010539a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010539e:	77 40                	ja     801053e0 <sys_fstat+0x60>
801053a0:	e8 6b e6 ff ff       	call   80103a10 <myproc>
801053a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801053a8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801053ac:	85 f6                	test   %esi,%esi
801053ae:	74 30                	je     801053e0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801053b0:	83 ec 04             	sub    $0x4,%esp
801053b3:	6a 14                	push   $0x14
801053b5:	53                   	push   %ebx
801053b6:	6a 01                	push   $0x1
801053b8:	e8 c3 fa ff ff       	call   80104e80 <argptr>
801053bd:	83 c4 10             	add    $0x10,%esp
801053c0:	85 c0                	test   %eax,%eax
801053c2:	78 1c                	js     801053e0 <sys_fstat+0x60>
  return filestat(f, st);
801053c4:	83 ec 08             	sub    $0x8,%esp
801053c7:	ff 75 f4             	push   -0xc(%ebp)
801053ca:	56                   	push   %esi
801053cb:	e8 20 bc ff ff       	call   80100ff0 <filestat>
801053d0:	83 c4 10             	add    $0x10,%esp
}
801053d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801053d6:	5b                   	pop    %ebx
801053d7:	5e                   	pop    %esi
801053d8:	5d                   	pop    %ebp
801053d9:	c3                   	ret    
801053da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801053e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053e5:	eb ec                	jmp    801053d3 <sys_fstat+0x53>
801053e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053ee:	66 90                	xchg   %ax,%ax

801053f0 <sys_link>:
{
801053f0:	55                   	push   %ebp
801053f1:	89 e5                	mov    %esp,%ebp
801053f3:	57                   	push   %edi
801053f4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801053f5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801053f8:	53                   	push   %ebx
801053f9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801053fc:	50                   	push   %eax
801053fd:	6a 00                	push   $0x0
801053ff:	e8 fc fa ff ff       	call   80104f00 <argstr>
80105404:	83 c4 10             	add    $0x10,%esp
80105407:	85 c0                	test   %eax,%eax
80105409:	0f 88 fb 00 00 00    	js     8010550a <sys_link+0x11a>
8010540f:	83 ec 08             	sub    $0x8,%esp
80105412:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105415:	50                   	push   %eax
80105416:	6a 01                	push   $0x1
80105418:	e8 e3 fa ff ff       	call   80104f00 <argstr>
8010541d:	83 c4 10             	add    $0x10,%esp
80105420:	85 c0                	test   %eax,%eax
80105422:	0f 88 e2 00 00 00    	js     8010550a <sys_link+0x11a>
  begin_op();
80105428:	e8 53 d9 ff ff       	call   80102d80 <begin_op>
  if((ip = namei(old)) == 0){
8010542d:	83 ec 0c             	sub    $0xc,%esp
80105430:	ff 75 d4             	push   -0x2c(%ebp)
80105433:	e8 88 cc ff ff       	call   801020c0 <namei>
80105438:	83 c4 10             	add    $0x10,%esp
8010543b:	89 c3                	mov    %eax,%ebx
8010543d:	85 c0                	test   %eax,%eax
8010543f:	0f 84 e4 00 00 00    	je     80105529 <sys_link+0x139>
  ilock(ip);
80105445:	83 ec 0c             	sub    $0xc,%esp
80105448:	50                   	push   %eax
80105449:	e8 52 c3 ff ff       	call   801017a0 <ilock>
  if(ip->type == T_DIR){
8010544e:	83 c4 10             	add    $0x10,%esp
80105451:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105456:	0f 84 b5 00 00 00    	je     80105511 <sys_link+0x121>
  iupdate(ip);
8010545c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010545f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105464:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105467:	53                   	push   %ebx
80105468:	e8 83 c2 ff ff       	call   801016f0 <iupdate>
  iunlock(ip);
8010546d:	89 1c 24             	mov    %ebx,(%esp)
80105470:	e8 0b c4 ff ff       	call   80101880 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105475:	58                   	pop    %eax
80105476:	5a                   	pop    %edx
80105477:	57                   	push   %edi
80105478:	ff 75 d0             	push   -0x30(%ebp)
8010547b:	e8 60 cc ff ff       	call   801020e0 <nameiparent>
80105480:	83 c4 10             	add    $0x10,%esp
80105483:	89 c6                	mov    %eax,%esi
80105485:	85 c0                	test   %eax,%eax
80105487:	74 5b                	je     801054e4 <sys_link+0xf4>
  ilock(dp);
80105489:	83 ec 0c             	sub    $0xc,%esp
8010548c:	50                   	push   %eax
8010548d:	e8 0e c3 ff ff       	call   801017a0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105492:	8b 03                	mov    (%ebx),%eax
80105494:	83 c4 10             	add    $0x10,%esp
80105497:	39 06                	cmp    %eax,(%esi)
80105499:	75 3d                	jne    801054d8 <sys_link+0xe8>
8010549b:	83 ec 04             	sub    $0x4,%esp
8010549e:	ff 73 04             	push   0x4(%ebx)
801054a1:	57                   	push   %edi
801054a2:	56                   	push   %esi
801054a3:	e8 58 cb ff ff       	call   80102000 <dirlink>
801054a8:	83 c4 10             	add    $0x10,%esp
801054ab:	85 c0                	test   %eax,%eax
801054ad:	78 29                	js     801054d8 <sys_link+0xe8>
  iunlockput(dp);
801054af:	83 ec 0c             	sub    $0xc,%esp
801054b2:	56                   	push   %esi
801054b3:	e8 78 c5 ff ff       	call   80101a30 <iunlockput>
  iput(ip);
801054b8:	89 1c 24             	mov    %ebx,(%esp)
801054bb:	e8 10 c4 ff ff       	call   801018d0 <iput>
  end_op();
801054c0:	e8 2b d9 ff ff       	call   80102df0 <end_op>
  return 0;
801054c5:	83 c4 10             	add    $0x10,%esp
801054c8:	31 c0                	xor    %eax,%eax
}
801054ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054cd:	5b                   	pop    %ebx
801054ce:	5e                   	pop    %esi
801054cf:	5f                   	pop    %edi
801054d0:	5d                   	pop    %ebp
801054d1:	c3                   	ret    
801054d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801054d8:	83 ec 0c             	sub    $0xc,%esp
801054db:	56                   	push   %esi
801054dc:	e8 4f c5 ff ff       	call   80101a30 <iunlockput>
    goto bad;
801054e1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801054e4:	83 ec 0c             	sub    $0xc,%esp
801054e7:	53                   	push   %ebx
801054e8:	e8 b3 c2 ff ff       	call   801017a0 <ilock>
  ip->nlink--;
801054ed:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801054f2:	89 1c 24             	mov    %ebx,(%esp)
801054f5:	e8 f6 c1 ff ff       	call   801016f0 <iupdate>
  iunlockput(ip);
801054fa:	89 1c 24             	mov    %ebx,(%esp)
801054fd:	e8 2e c5 ff ff       	call   80101a30 <iunlockput>
  end_op();
80105502:	e8 e9 d8 ff ff       	call   80102df0 <end_op>
  return -1;
80105507:	83 c4 10             	add    $0x10,%esp
8010550a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010550f:	eb b9                	jmp    801054ca <sys_link+0xda>
    iunlockput(ip);
80105511:	83 ec 0c             	sub    $0xc,%esp
80105514:	53                   	push   %ebx
80105515:	e8 16 c5 ff ff       	call   80101a30 <iunlockput>
    end_op();
8010551a:	e8 d1 d8 ff ff       	call   80102df0 <end_op>
    return -1;
8010551f:	83 c4 10             	add    $0x10,%esp
80105522:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105527:	eb a1                	jmp    801054ca <sys_link+0xda>
    end_op();
80105529:	e8 c2 d8 ff ff       	call   80102df0 <end_op>
    return -1;
8010552e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105533:	eb 95                	jmp    801054ca <sys_link+0xda>
80105535:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010553c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105540 <sys_unlink>:
{
80105540:	55                   	push   %ebp
80105541:	89 e5                	mov    %esp,%ebp
80105543:	57                   	push   %edi
80105544:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105545:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105548:	53                   	push   %ebx
80105549:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010554c:	50                   	push   %eax
8010554d:	6a 00                	push   $0x0
8010554f:	e8 ac f9 ff ff       	call   80104f00 <argstr>
80105554:	83 c4 10             	add    $0x10,%esp
80105557:	85 c0                	test   %eax,%eax
80105559:	0f 88 7a 01 00 00    	js     801056d9 <sys_unlink+0x199>
  begin_op();
8010555f:	e8 1c d8 ff ff       	call   80102d80 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105564:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105567:	83 ec 08             	sub    $0x8,%esp
8010556a:	53                   	push   %ebx
8010556b:	ff 75 c0             	push   -0x40(%ebp)
8010556e:	e8 6d cb ff ff       	call   801020e0 <nameiparent>
80105573:	83 c4 10             	add    $0x10,%esp
80105576:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105579:	85 c0                	test   %eax,%eax
8010557b:	0f 84 62 01 00 00    	je     801056e3 <sys_unlink+0x1a3>
  ilock(dp);
80105581:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105584:	83 ec 0c             	sub    $0xc,%esp
80105587:	57                   	push   %edi
80105588:	e8 13 c2 ff ff       	call   801017a0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010558d:	58                   	pop    %eax
8010558e:	5a                   	pop    %edx
8010558f:	68 e0 7f 10 80       	push   $0x80107fe0
80105594:	53                   	push   %ebx
80105595:	e8 46 c7 ff ff       	call   80101ce0 <namecmp>
8010559a:	83 c4 10             	add    $0x10,%esp
8010559d:	85 c0                	test   %eax,%eax
8010559f:	0f 84 fb 00 00 00    	je     801056a0 <sys_unlink+0x160>
801055a5:	83 ec 08             	sub    $0x8,%esp
801055a8:	68 df 7f 10 80       	push   $0x80107fdf
801055ad:	53                   	push   %ebx
801055ae:	e8 2d c7 ff ff       	call   80101ce0 <namecmp>
801055b3:	83 c4 10             	add    $0x10,%esp
801055b6:	85 c0                	test   %eax,%eax
801055b8:	0f 84 e2 00 00 00    	je     801056a0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
801055be:	83 ec 04             	sub    $0x4,%esp
801055c1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801055c4:	50                   	push   %eax
801055c5:	53                   	push   %ebx
801055c6:	57                   	push   %edi
801055c7:	e8 34 c7 ff ff       	call   80101d00 <dirlookup>
801055cc:	83 c4 10             	add    $0x10,%esp
801055cf:	89 c3                	mov    %eax,%ebx
801055d1:	85 c0                	test   %eax,%eax
801055d3:	0f 84 c7 00 00 00    	je     801056a0 <sys_unlink+0x160>
  ilock(ip);
801055d9:	83 ec 0c             	sub    $0xc,%esp
801055dc:	50                   	push   %eax
801055dd:	e8 be c1 ff ff       	call   801017a0 <ilock>
  if(ip->nlink < 1)
801055e2:	83 c4 10             	add    $0x10,%esp
801055e5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801055ea:	0f 8e 1c 01 00 00    	jle    8010570c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
801055f0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055f5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801055f8:	74 66                	je     80105660 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801055fa:	83 ec 04             	sub    $0x4,%esp
801055fd:	6a 10                	push   $0x10
801055ff:	6a 00                	push   $0x0
80105601:	57                   	push   %edi
80105602:	e8 59 f5 ff ff       	call   80104b60 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105607:	6a 10                	push   $0x10
80105609:	ff 75 c4             	push   -0x3c(%ebp)
8010560c:	57                   	push   %edi
8010560d:	ff 75 b4             	push   -0x4c(%ebp)
80105610:	e8 9b c5 ff ff       	call   80101bb0 <writei>
80105615:	83 c4 20             	add    $0x20,%esp
80105618:	83 f8 10             	cmp    $0x10,%eax
8010561b:	0f 85 de 00 00 00    	jne    801056ff <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80105621:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105626:	0f 84 94 00 00 00    	je     801056c0 <sys_unlink+0x180>
  iunlockput(dp);
8010562c:	83 ec 0c             	sub    $0xc,%esp
8010562f:	ff 75 b4             	push   -0x4c(%ebp)
80105632:	e8 f9 c3 ff ff       	call   80101a30 <iunlockput>
  ip->nlink--;
80105637:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010563c:	89 1c 24             	mov    %ebx,(%esp)
8010563f:	e8 ac c0 ff ff       	call   801016f0 <iupdate>
  iunlockput(ip);
80105644:	89 1c 24             	mov    %ebx,(%esp)
80105647:	e8 e4 c3 ff ff       	call   80101a30 <iunlockput>
  end_op();
8010564c:	e8 9f d7 ff ff       	call   80102df0 <end_op>
  return 0;
80105651:	83 c4 10             	add    $0x10,%esp
80105654:	31 c0                	xor    %eax,%eax
}
80105656:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105659:	5b                   	pop    %ebx
8010565a:	5e                   	pop    %esi
8010565b:	5f                   	pop    %edi
8010565c:	5d                   	pop    %ebp
8010565d:	c3                   	ret    
8010565e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105660:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105664:	76 94                	jbe    801055fa <sys_unlink+0xba>
80105666:	be 20 00 00 00       	mov    $0x20,%esi
8010566b:	eb 0b                	jmp    80105678 <sys_unlink+0x138>
8010566d:	8d 76 00             	lea    0x0(%esi),%esi
80105670:	83 c6 10             	add    $0x10,%esi
80105673:	3b 73 58             	cmp    0x58(%ebx),%esi
80105676:	73 82                	jae    801055fa <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105678:	6a 10                	push   $0x10
8010567a:	56                   	push   %esi
8010567b:	57                   	push   %edi
8010567c:	53                   	push   %ebx
8010567d:	e8 2e c4 ff ff       	call   80101ab0 <readi>
80105682:	83 c4 10             	add    $0x10,%esp
80105685:	83 f8 10             	cmp    $0x10,%eax
80105688:	75 68                	jne    801056f2 <sys_unlink+0x1b2>
    if(de.inum != 0)
8010568a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010568f:	74 df                	je     80105670 <sys_unlink+0x130>
    iunlockput(ip);
80105691:	83 ec 0c             	sub    $0xc,%esp
80105694:	53                   	push   %ebx
80105695:	e8 96 c3 ff ff       	call   80101a30 <iunlockput>
    goto bad;
8010569a:	83 c4 10             	add    $0x10,%esp
8010569d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
801056a0:	83 ec 0c             	sub    $0xc,%esp
801056a3:	ff 75 b4             	push   -0x4c(%ebp)
801056a6:	e8 85 c3 ff ff       	call   80101a30 <iunlockput>
  end_op();
801056ab:	e8 40 d7 ff ff       	call   80102df0 <end_op>
  return -1;
801056b0:	83 c4 10             	add    $0x10,%esp
801056b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056b8:	eb 9c                	jmp    80105656 <sys_unlink+0x116>
801056ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
801056c0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
801056c3:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801056c6:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801056cb:	50                   	push   %eax
801056cc:	e8 1f c0 ff ff       	call   801016f0 <iupdate>
801056d1:	83 c4 10             	add    $0x10,%esp
801056d4:	e9 53 ff ff ff       	jmp    8010562c <sys_unlink+0xec>
    return -1;
801056d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056de:	e9 73 ff ff ff       	jmp    80105656 <sys_unlink+0x116>
    end_op();
801056e3:	e8 08 d7 ff ff       	call   80102df0 <end_op>
    return -1;
801056e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056ed:	e9 64 ff ff ff       	jmp    80105656 <sys_unlink+0x116>
      panic("isdirempty: readi");
801056f2:	83 ec 0c             	sub    $0xc,%esp
801056f5:	68 04 80 10 80       	push   $0x80108004
801056fa:	e8 81 ac ff ff       	call   80100380 <panic>
    panic("unlink: writei");
801056ff:	83 ec 0c             	sub    $0xc,%esp
80105702:	68 16 80 10 80       	push   $0x80108016
80105707:	e8 74 ac ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010570c:	83 ec 0c             	sub    $0xc,%esp
8010570f:	68 f2 7f 10 80       	push   $0x80107ff2
80105714:	e8 67 ac ff ff       	call   80100380 <panic>
80105719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105720 <sys_open>:

int
sys_open(void)
{
80105720:	55                   	push   %ebp
80105721:	89 e5                	mov    %esp,%ebp
80105723:	57                   	push   %edi
80105724:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105725:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105728:	53                   	push   %ebx
80105729:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010572c:	50                   	push   %eax
8010572d:	6a 00                	push   $0x0
8010572f:	e8 cc f7 ff ff       	call   80104f00 <argstr>
80105734:	83 c4 10             	add    $0x10,%esp
80105737:	85 c0                	test   %eax,%eax
80105739:	0f 88 8e 00 00 00    	js     801057cd <sys_open+0xad>
8010573f:	83 ec 08             	sub    $0x8,%esp
80105742:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105745:	50                   	push   %eax
80105746:	6a 01                	push   $0x1
80105748:	e8 e3 f6 ff ff       	call   80104e30 <argint>
8010574d:	83 c4 10             	add    $0x10,%esp
80105750:	85 c0                	test   %eax,%eax
80105752:	78 79                	js     801057cd <sys_open+0xad>
    return -1;

  begin_op();
80105754:	e8 27 d6 ff ff       	call   80102d80 <begin_op>

  if(omode & O_CREATE){
80105759:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010575d:	75 79                	jne    801057d8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010575f:	83 ec 0c             	sub    $0xc,%esp
80105762:	ff 75 e0             	push   -0x20(%ebp)
80105765:	e8 56 c9 ff ff       	call   801020c0 <namei>
8010576a:	83 c4 10             	add    $0x10,%esp
8010576d:	89 c6                	mov    %eax,%esi
8010576f:	85 c0                	test   %eax,%eax
80105771:	0f 84 7e 00 00 00    	je     801057f5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105777:	83 ec 0c             	sub    $0xc,%esp
8010577a:	50                   	push   %eax
8010577b:	e8 20 c0 ff ff       	call   801017a0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105780:	83 c4 10             	add    $0x10,%esp
80105783:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105788:	0f 84 c2 00 00 00    	je     80105850 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010578e:	e8 bd b6 ff ff       	call   80100e50 <filealloc>
80105793:	89 c7                	mov    %eax,%edi
80105795:	85 c0                	test   %eax,%eax
80105797:	74 23                	je     801057bc <sys_open+0x9c>
  struct proc *curproc = myproc();
80105799:	e8 72 e2 ff ff       	call   80103a10 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010579e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801057a0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801057a4:	85 d2                	test   %edx,%edx
801057a6:	74 60                	je     80105808 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801057a8:	83 c3 01             	add    $0x1,%ebx
801057ab:	83 fb 10             	cmp    $0x10,%ebx
801057ae:	75 f0                	jne    801057a0 <sys_open+0x80>
    if(f)
      fileclose(f);
801057b0:	83 ec 0c             	sub    $0xc,%esp
801057b3:	57                   	push   %edi
801057b4:	e8 57 b7 ff ff       	call   80100f10 <fileclose>
801057b9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801057bc:	83 ec 0c             	sub    $0xc,%esp
801057bf:	56                   	push   %esi
801057c0:	e8 6b c2 ff ff       	call   80101a30 <iunlockput>
    end_op();
801057c5:	e8 26 d6 ff ff       	call   80102df0 <end_op>
    return -1;
801057ca:	83 c4 10             	add    $0x10,%esp
801057cd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801057d2:	eb 6d                	jmp    80105841 <sys_open+0x121>
801057d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801057d8:	83 ec 0c             	sub    $0xc,%esp
801057db:	8b 45 e0             	mov    -0x20(%ebp),%eax
801057de:	31 c9                	xor    %ecx,%ecx
801057e0:	ba 02 00 00 00       	mov    $0x2,%edx
801057e5:	6a 00                	push   $0x0
801057e7:	e8 14 f8 ff ff       	call   80105000 <create>
    if(ip == 0){
801057ec:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801057ef:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801057f1:	85 c0                	test   %eax,%eax
801057f3:	75 99                	jne    8010578e <sys_open+0x6e>
      end_op();
801057f5:	e8 f6 d5 ff ff       	call   80102df0 <end_op>
      return -1;
801057fa:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801057ff:	eb 40                	jmp    80105841 <sys_open+0x121>
80105801:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105808:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010580b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010580f:	56                   	push   %esi
80105810:	e8 6b c0 ff ff       	call   80101880 <iunlock>
  end_op();
80105815:	e8 d6 d5 ff ff       	call   80102df0 <end_op>

  f->type = FD_INODE;
8010581a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105820:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105823:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105826:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105829:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010582b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105832:	f7 d0                	not    %eax
80105834:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105837:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010583a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010583d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105841:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105844:	89 d8                	mov    %ebx,%eax
80105846:	5b                   	pop    %ebx
80105847:	5e                   	pop    %esi
80105848:	5f                   	pop    %edi
80105849:	5d                   	pop    %ebp
8010584a:	c3                   	ret    
8010584b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010584f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105850:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105853:	85 c9                	test   %ecx,%ecx
80105855:	0f 84 33 ff ff ff    	je     8010578e <sys_open+0x6e>
8010585b:	e9 5c ff ff ff       	jmp    801057bc <sys_open+0x9c>

80105860 <sys_mkdir>:

int
sys_mkdir(void)
{
80105860:	55                   	push   %ebp
80105861:	89 e5                	mov    %esp,%ebp
80105863:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105866:	e8 15 d5 ff ff       	call   80102d80 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010586b:	83 ec 08             	sub    $0x8,%esp
8010586e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105871:	50                   	push   %eax
80105872:	6a 00                	push   $0x0
80105874:	e8 87 f6 ff ff       	call   80104f00 <argstr>
80105879:	83 c4 10             	add    $0x10,%esp
8010587c:	85 c0                	test   %eax,%eax
8010587e:	78 30                	js     801058b0 <sys_mkdir+0x50>
80105880:	83 ec 0c             	sub    $0xc,%esp
80105883:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105886:	31 c9                	xor    %ecx,%ecx
80105888:	ba 01 00 00 00       	mov    $0x1,%edx
8010588d:	6a 00                	push   $0x0
8010588f:	e8 6c f7 ff ff       	call   80105000 <create>
80105894:	83 c4 10             	add    $0x10,%esp
80105897:	85 c0                	test   %eax,%eax
80105899:	74 15                	je     801058b0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010589b:	83 ec 0c             	sub    $0xc,%esp
8010589e:	50                   	push   %eax
8010589f:	e8 8c c1 ff ff       	call   80101a30 <iunlockput>
  end_op();
801058a4:	e8 47 d5 ff ff       	call   80102df0 <end_op>
  return 0;
801058a9:	83 c4 10             	add    $0x10,%esp
801058ac:	31 c0                	xor    %eax,%eax
}
801058ae:	c9                   	leave  
801058af:	c3                   	ret    
    end_op();
801058b0:	e8 3b d5 ff ff       	call   80102df0 <end_op>
    return -1;
801058b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058ba:	c9                   	leave  
801058bb:	c3                   	ret    
801058bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058c0 <sys_mknod>:

int
sys_mknod(void)
{
801058c0:	55                   	push   %ebp
801058c1:	89 e5                	mov    %esp,%ebp
801058c3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801058c6:	e8 b5 d4 ff ff       	call   80102d80 <begin_op>
  if((argstr(0, &path)) < 0 ||
801058cb:	83 ec 08             	sub    $0x8,%esp
801058ce:	8d 45 ec             	lea    -0x14(%ebp),%eax
801058d1:	50                   	push   %eax
801058d2:	6a 00                	push   $0x0
801058d4:	e8 27 f6 ff ff       	call   80104f00 <argstr>
801058d9:	83 c4 10             	add    $0x10,%esp
801058dc:	85 c0                	test   %eax,%eax
801058de:	78 60                	js     80105940 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801058e0:	83 ec 08             	sub    $0x8,%esp
801058e3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058e6:	50                   	push   %eax
801058e7:	6a 01                	push   $0x1
801058e9:	e8 42 f5 ff ff       	call   80104e30 <argint>
  if((argstr(0, &path)) < 0 ||
801058ee:	83 c4 10             	add    $0x10,%esp
801058f1:	85 c0                	test   %eax,%eax
801058f3:	78 4b                	js     80105940 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801058f5:	83 ec 08             	sub    $0x8,%esp
801058f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058fb:	50                   	push   %eax
801058fc:	6a 02                	push   $0x2
801058fe:	e8 2d f5 ff ff       	call   80104e30 <argint>
     argint(1, &major) < 0 ||
80105903:	83 c4 10             	add    $0x10,%esp
80105906:	85 c0                	test   %eax,%eax
80105908:	78 36                	js     80105940 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010590a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010590e:	83 ec 0c             	sub    $0xc,%esp
80105911:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105915:	ba 03 00 00 00       	mov    $0x3,%edx
8010591a:	50                   	push   %eax
8010591b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010591e:	e8 dd f6 ff ff       	call   80105000 <create>
     argint(2, &minor) < 0 ||
80105923:	83 c4 10             	add    $0x10,%esp
80105926:	85 c0                	test   %eax,%eax
80105928:	74 16                	je     80105940 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010592a:	83 ec 0c             	sub    $0xc,%esp
8010592d:	50                   	push   %eax
8010592e:	e8 fd c0 ff ff       	call   80101a30 <iunlockput>
  end_op();
80105933:	e8 b8 d4 ff ff       	call   80102df0 <end_op>
  return 0;
80105938:	83 c4 10             	add    $0x10,%esp
8010593b:	31 c0                	xor    %eax,%eax
}
8010593d:	c9                   	leave  
8010593e:	c3                   	ret    
8010593f:	90                   	nop
    end_op();
80105940:	e8 ab d4 ff ff       	call   80102df0 <end_op>
    return -1;
80105945:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010594a:	c9                   	leave  
8010594b:	c3                   	ret    
8010594c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105950 <sys_chdir>:

int
sys_chdir(void)
{
80105950:	55                   	push   %ebp
80105951:	89 e5                	mov    %esp,%ebp
80105953:	56                   	push   %esi
80105954:	53                   	push   %ebx
80105955:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105958:	e8 b3 e0 ff ff       	call   80103a10 <myproc>
8010595d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010595f:	e8 1c d4 ff ff       	call   80102d80 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105964:	83 ec 08             	sub    $0x8,%esp
80105967:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010596a:	50                   	push   %eax
8010596b:	6a 00                	push   $0x0
8010596d:	e8 8e f5 ff ff       	call   80104f00 <argstr>
80105972:	83 c4 10             	add    $0x10,%esp
80105975:	85 c0                	test   %eax,%eax
80105977:	78 77                	js     801059f0 <sys_chdir+0xa0>
80105979:	83 ec 0c             	sub    $0xc,%esp
8010597c:	ff 75 f4             	push   -0xc(%ebp)
8010597f:	e8 3c c7 ff ff       	call   801020c0 <namei>
80105984:	83 c4 10             	add    $0x10,%esp
80105987:	89 c3                	mov    %eax,%ebx
80105989:	85 c0                	test   %eax,%eax
8010598b:	74 63                	je     801059f0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010598d:	83 ec 0c             	sub    $0xc,%esp
80105990:	50                   	push   %eax
80105991:	e8 0a be ff ff       	call   801017a0 <ilock>
  if(ip->type != T_DIR){
80105996:	83 c4 10             	add    $0x10,%esp
80105999:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010599e:	75 30                	jne    801059d0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801059a0:	83 ec 0c             	sub    $0xc,%esp
801059a3:	53                   	push   %ebx
801059a4:	e8 d7 be ff ff       	call   80101880 <iunlock>
  iput(curproc->cwd);
801059a9:	58                   	pop    %eax
801059aa:	ff 76 68             	push   0x68(%esi)
801059ad:	e8 1e bf ff ff       	call   801018d0 <iput>
  end_op();
801059b2:	e8 39 d4 ff ff       	call   80102df0 <end_op>
  curproc->cwd = ip;
801059b7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801059ba:	83 c4 10             	add    $0x10,%esp
801059bd:	31 c0                	xor    %eax,%eax
}
801059bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801059c2:	5b                   	pop    %ebx
801059c3:	5e                   	pop    %esi
801059c4:	5d                   	pop    %ebp
801059c5:	c3                   	ret    
801059c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059cd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801059d0:	83 ec 0c             	sub    $0xc,%esp
801059d3:	53                   	push   %ebx
801059d4:	e8 57 c0 ff ff       	call   80101a30 <iunlockput>
    end_op();
801059d9:	e8 12 d4 ff ff       	call   80102df0 <end_op>
    return -1;
801059de:	83 c4 10             	add    $0x10,%esp
801059e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059e6:	eb d7                	jmp    801059bf <sys_chdir+0x6f>
801059e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059ef:	90                   	nop
    end_op();
801059f0:	e8 fb d3 ff ff       	call   80102df0 <end_op>
    return -1;
801059f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059fa:	eb c3                	jmp    801059bf <sys_chdir+0x6f>
801059fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a00 <sys_exec>:

int
sys_exec(void)
{
80105a00:	55                   	push   %ebp
80105a01:	89 e5                	mov    %esp,%ebp
80105a03:	57                   	push   %edi
80105a04:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105a05:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105a0b:	53                   	push   %ebx
80105a0c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105a12:	50                   	push   %eax
80105a13:	6a 00                	push   $0x0
80105a15:	e8 e6 f4 ff ff       	call   80104f00 <argstr>
80105a1a:	83 c4 10             	add    $0x10,%esp
80105a1d:	85 c0                	test   %eax,%eax
80105a1f:	0f 88 87 00 00 00    	js     80105aac <sys_exec+0xac>
80105a25:	83 ec 08             	sub    $0x8,%esp
80105a28:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105a2e:	50                   	push   %eax
80105a2f:	6a 01                	push   $0x1
80105a31:	e8 fa f3 ff ff       	call   80104e30 <argint>
80105a36:	83 c4 10             	add    $0x10,%esp
80105a39:	85 c0                	test   %eax,%eax
80105a3b:	78 6f                	js     80105aac <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105a3d:	83 ec 04             	sub    $0x4,%esp
80105a40:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105a46:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105a48:	68 80 00 00 00       	push   $0x80
80105a4d:	6a 00                	push   $0x0
80105a4f:	56                   	push   %esi
80105a50:	e8 0b f1 ff ff       	call   80104b60 <memset>
80105a55:	83 c4 10             	add    $0x10,%esp
80105a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a5f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105a60:	83 ec 08             	sub    $0x8,%esp
80105a63:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105a69:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105a70:	50                   	push   %eax
80105a71:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105a77:	01 f8                	add    %edi,%eax
80105a79:	50                   	push   %eax
80105a7a:	e8 11 f3 ff ff       	call   80104d90 <fetchint>
80105a7f:	83 c4 10             	add    $0x10,%esp
80105a82:	85 c0                	test   %eax,%eax
80105a84:	78 26                	js     80105aac <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105a86:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105a8c:	85 c0                	test   %eax,%eax
80105a8e:	74 30                	je     80105ac0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105a90:	83 ec 08             	sub    $0x8,%esp
80105a93:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105a96:	52                   	push   %edx
80105a97:	50                   	push   %eax
80105a98:	e8 33 f3 ff ff       	call   80104dd0 <fetchstr>
80105a9d:	83 c4 10             	add    $0x10,%esp
80105aa0:	85 c0                	test   %eax,%eax
80105aa2:	78 08                	js     80105aac <sys_exec+0xac>
  for(i=0;; i++){
80105aa4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105aa7:	83 fb 20             	cmp    $0x20,%ebx
80105aaa:	75 b4                	jne    80105a60 <sys_exec+0x60>
      return -1;
  }
  merge(myproc());
  return exec(path, argv);
}
80105aac:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105aaf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ab4:	5b                   	pop    %ebx
80105ab5:	5e                   	pop    %esi
80105ab6:	5f                   	pop    %edi
80105ab7:	5d                   	pop    %ebp
80105ab8:	c3                   	ret    
80105ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105ac0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105ac7:	00 00 00 00 
  merge(myproc());
80105acb:	e8 40 df ff ff       	call   80103a10 <myproc>
80105ad0:	83 ec 0c             	sub    $0xc,%esp
80105ad3:	50                   	push   %eax
80105ad4:	e8 57 ec ff ff       	call   80104730 <merge>
  return exec(path, argv);
80105ad9:	58                   	pop    %eax
80105ada:	5a                   	pop    %edx
80105adb:	56                   	push   %esi
80105adc:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105ae2:	e8 c9 af ff ff       	call   80100ab0 <exec>
80105ae7:	83 c4 10             	add    $0x10,%esp
}
80105aea:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105aed:	5b                   	pop    %ebx
80105aee:	5e                   	pop    %esi
80105aef:	5f                   	pop    %edi
80105af0:	5d                   	pop    %ebp
80105af1:	c3                   	ret    
80105af2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105b00 <sys_pipe>:

int
sys_pipe(void)
{
80105b00:	55                   	push   %ebp
80105b01:	89 e5                	mov    %esp,%ebp
80105b03:	57                   	push   %edi
80105b04:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105b05:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105b08:	53                   	push   %ebx
80105b09:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105b0c:	6a 08                	push   $0x8
80105b0e:	50                   	push   %eax
80105b0f:	6a 00                	push   $0x0
80105b11:	e8 6a f3 ff ff       	call   80104e80 <argptr>
80105b16:	83 c4 10             	add    $0x10,%esp
80105b19:	85 c0                	test   %eax,%eax
80105b1b:	78 4a                	js     80105b67 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105b1d:	83 ec 08             	sub    $0x8,%esp
80105b20:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105b23:	50                   	push   %eax
80105b24:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105b27:	50                   	push   %eax
80105b28:	e8 23 d9 ff ff       	call   80103450 <pipealloc>
80105b2d:	83 c4 10             	add    $0x10,%esp
80105b30:	85 c0                	test   %eax,%eax
80105b32:	78 33                	js     80105b67 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105b34:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105b37:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105b39:	e8 d2 de ff ff       	call   80103a10 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105b3e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105b40:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105b44:	85 f6                	test   %esi,%esi
80105b46:	74 28                	je     80105b70 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105b48:	83 c3 01             	add    $0x1,%ebx
80105b4b:	83 fb 10             	cmp    $0x10,%ebx
80105b4e:	75 f0                	jne    80105b40 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105b50:	83 ec 0c             	sub    $0xc,%esp
80105b53:	ff 75 e0             	push   -0x20(%ebp)
80105b56:	e8 b5 b3 ff ff       	call   80100f10 <fileclose>
    fileclose(wf);
80105b5b:	58                   	pop    %eax
80105b5c:	ff 75 e4             	push   -0x1c(%ebp)
80105b5f:	e8 ac b3 ff ff       	call   80100f10 <fileclose>
    return -1;
80105b64:	83 c4 10             	add    $0x10,%esp
80105b67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b6c:	eb 53                	jmp    80105bc1 <sys_pipe+0xc1>
80105b6e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105b70:	8d 73 08             	lea    0x8(%ebx),%esi
80105b73:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105b77:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105b7a:	e8 91 de ff ff       	call   80103a10 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105b7f:	31 d2                	xor    %edx,%edx
80105b81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105b88:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105b8c:	85 c9                	test   %ecx,%ecx
80105b8e:	74 20                	je     80105bb0 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105b90:	83 c2 01             	add    $0x1,%edx
80105b93:	83 fa 10             	cmp    $0x10,%edx
80105b96:	75 f0                	jne    80105b88 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105b98:	e8 73 de ff ff       	call   80103a10 <myproc>
80105b9d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105ba4:	00 
80105ba5:	eb a9                	jmp    80105b50 <sys_pipe+0x50>
80105ba7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bae:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105bb0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105bb4:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105bb7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105bb9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105bbc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105bbf:	31 c0                	xor    %eax,%eax
}
80105bc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bc4:	5b                   	pop    %ebx
80105bc5:	5e                   	pop    %esi
80105bc6:	5f                   	pop    %edi
80105bc7:	5d                   	pop    %ebp
80105bc8:	c3                   	ret    
80105bc9:	66 90                	xchg   %ax,%ax
80105bcb:	66 90                	xchg   %ax,%ax
80105bcd:	66 90                	xchg   %ax,%ax
80105bcf:	90                   	nop

80105bd0 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105bd0:	e9 eb df ff ff       	jmp    80103bc0 <fork>
80105bd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105be0 <sys_exit>:
}

int
sys_exit(void)
{
80105be0:	55                   	push   %ebp
80105be1:	89 e5                	mov    %esp,%ebp
80105be3:	83 ec 08             	sub    $0x8,%esp
  merge(myproc());
80105be6:	e8 25 de ff ff       	call   80103a10 <myproc>
80105beb:	83 ec 0c             	sub    $0xc,%esp
80105bee:	50                   	push   %eax
80105bef:	e8 3c eb ff ff       	call   80104730 <merge>
  if (myproc()->tid <= 1)
80105bf4:	e8 17 de ff ff       	call   80103a10 <myproc>
80105bf9:	83 c4 10             	add    $0x10,%esp
80105bfc:	83 b8 80 00 00 00 01 	cmpl   $0x1,0x80(%eax)
80105c03:	7e 1b                	jle    80105c20 <sys_exit+0x40>
    exit();
  else
    thread_exit(0);
80105c05:	83 ec 0c             	sub    $0xc,%esp
80105c08:	6a 00                	push   $0x0
80105c0a:	e8 e1 e8 ff ff       	call   801044f0 <thread_exit>
80105c0f:	83 c4 10             	add    $0x10,%esp
  return 0;  // not reached
}
80105c12:	31 c0                	xor    %eax,%eax
80105c14:	c9                   	leave  
80105c15:	c3                   	ret    
80105c16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c1d:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80105c20:	e8 2b e2 ff ff       	call   80103e50 <exit>
}
80105c25:	31 c0                	xor    %eax,%eax
80105c27:	c9                   	leave  
80105c28:	c3                   	ret    
80105c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105c30 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105c30:	e9 1b e3 ff ff       	jmp    80103f50 <wait>
80105c35:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c40 <sys_kill>:
}

int
sys_kill(void)
{
80105c40:	55                   	push   %ebp
80105c41:	89 e5                	mov    %esp,%ebp
80105c43:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105c46:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c49:	50                   	push   %eax
80105c4a:	6a 00                	push   $0x0
80105c4c:	e8 df f1 ff ff       	call   80104e30 <argint>
80105c51:	83 c4 10             	add    $0x10,%esp
80105c54:	85 c0                	test   %eax,%eax
80105c56:	78 18                	js     80105c70 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105c58:	83 ec 0c             	sub    $0xc,%esp
80105c5b:	ff 75 f4             	push   -0xc(%ebp)
80105c5e:	e8 bd e5 ff ff       	call   80104220 <kill>
80105c63:	83 c4 10             	add    $0x10,%esp
}
80105c66:	c9                   	leave  
80105c67:	c3                   	ret    
80105c68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c6f:	90                   	nop
80105c70:	c9                   	leave  
    return -1;
80105c71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c76:	c3                   	ret    
80105c77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c7e:	66 90                	xchg   %ax,%ax

80105c80 <sys_getpid>:

int
sys_getpid(void)
{
80105c80:	55                   	push   %ebp
80105c81:	89 e5                	mov    %esp,%ebp
80105c83:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105c86:	e8 85 dd ff ff       	call   80103a10 <myproc>
80105c8b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105c8e:	c9                   	leave  
80105c8f:	c3                   	ret    

80105c90 <sys_sbrk>:

int
sys_sbrk(void)
{
80105c90:	55                   	push   %ebp
80105c91:	89 e5                	mov    %esp,%ebp
80105c93:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105c94:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105c97:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105c9a:	50                   	push   %eax
80105c9b:	6a 00                	push   $0x0
80105c9d:	e8 8e f1 ff ff       	call   80104e30 <argint>
80105ca2:	83 c4 10             	add    $0x10,%esp
80105ca5:	85 c0                	test   %eax,%eax
80105ca7:	78 27                	js     80105cd0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->mthread->sz;
80105ca9:	e8 62 dd ff ff       	call   80103a10 <myproc>
  if(growproc(n) < 0)
80105cae:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->mthread->sz;
80105cb1:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80105cb7:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105cb9:	ff 75 f4             	push   -0xc(%ebp)
80105cbc:	e8 6f de ff ff       	call   80103b30 <growproc>
80105cc1:	83 c4 10             	add    $0x10,%esp
80105cc4:	85 c0                	test   %eax,%eax
80105cc6:	78 08                	js     80105cd0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105cc8:	89 d8                	mov    %ebx,%eax
80105cca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ccd:	c9                   	leave  
80105cce:	c3                   	ret    
80105ccf:	90                   	nop
    return -1;
80105cd0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105cd5:	eb f1                	jmp    80105cc8 <sys_sbrk+0x38>
80105cd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cde:	66 90                	xchg   %ax,%ax

80105ce0 <sys_sleep>:

int
sys_sleep(void)
{
80105ce0:	55                   	push   %ebp
80105ce1:	89 e5                	mov    %esp,%ebp
80105ce3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105ce4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105ce7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105cea:	50                   	push   %eax
80105ceb:	6a 00                	push   $0x0
80105ced:	e8 3e f1 ff ff       	call   80104e30 <argint>
80105cf2:	83 c4 10             	add    $0x10,%esp
80105cf5:	85 c0                	test   %eax,%eax
80105cf7:	0f 88 8a 00 00 00    	js     80105d87 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105cfd:	83 ec 0c             	sub    $0xc,%esp
80105d00:	68 80 50 11 80       	push   $0x80115080
80105d05:	e8 96 ed ff ff       	call   80104aa0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105d0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105d0d:	8b 1d 60 50 11 80    	mov    0x80115060,%ebx
  while(ticks - ticks0 < n){
80105d13:	83 c4 10             	add    $0x10,%esp
80105d16:	85 d2                	test   %edx,%edx
80105d18:	75 27                	jne    80105d41 <sys_sleep+0x61>
80105d1a:	eb 54                	jmp    80105d70 <sys_sleep+0x90>
80105d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105d20:	83 ec 08             	sub    $0x8,%esp
80105d23:	68 80 50 11 80       	push   $0x80115080
80105d28:	68 60 50 11 80       	push   $0x80115060
80105d2d:	e8 ce e3 ff ff       	call   80104100 <sleep>
  while(ticks - ticks0 < n){
80105d32:	a1 60 50 11 80       	mov    0x80115060,%eax
80105d37:	83 c4 10             	add    $0x10,%esp
80105d3a:	29 d8                	sub    %ebx,%eax
80105d3c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105d3f:	73 2f                	jae    80105d70 <sys_sleep+0x90>
    if(myproc()->killed){
80105d41:	e8 ca dc ff ff       	call   80103a10 <myproc>
80105d46:	8b 40 24             	mov    0x24(%eax),%eax
80105d49:	85 c0                	test   %eax,%eax
80105d4b:	74 d3                	je     80105d20 <sys_sleep+0x40>
      release(&tickslock);
80105d4d:	83 ec 0c             	sub    $0xc,%esp
80105d50:	68 80 50 11 80       	push   $0x80115080
80105d55:	e8 e6 ec ff ff       	call   80104a40 <release>
  }
  release(&tickslock);
  return 0;
}
80105d5a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105d5d:	83 c4 10             	add    $0x10,%esp
80105d60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d65:	c9                   	leave  
80105d66:	c3                   	ret    
80105d67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d6e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105d70:	83 ec 0c             	sub    $0xc,%esp
80105d73:	68 80 50 11 80       	push   $0x80115080
80105d78:	e8 c3 ec ff ff       	call   80104a40 <release>
  return 0;
80105d7d:	83 c4 10             	add    $0x10,%esp
80105d80:	31 c0                	xor    %eax,%eax
}
80105d82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d85:	c9                   	leave  
80105d86:	c3                   	ret    
    return -1;
80105d87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d8c:	eb f4                	jmp    80105d82 <sys_sleep+0xa2>
80105d8e:	66 90                	xchg   %ax,%ax

80105d90 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105d90:	55                   	push   %ebp
80105d91:	89 e5                	mov    %esp,%ebp
80105d93:	53                   	push   %ebx
80105d94:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105d97:	68 80 50 11 80       	push   $0x80115080
80105d9c:	e8 ff ec ff ff       	call   80104aa0 <acquire>
  xticks = ticks;
80105da1:	8b 1d 60 50 11 80    	mov    0x80115060,%ebx
  release(&tickslock);
80105da7:	c7 04 24 80 50 11 80 	movl   $0x80115080,(%esp)
80105dae:	e8 8d ec ff ff       	call   80104a40 <release>
  return xticks;
}
80105db3:	89 d8                	mov    %ebx,%eax
80105db5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105db8:	c9                   	leave  
80105db9:	c3                   	ret    
80105dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105dc0 <sys_thread_create>:

int 
sys_thread_create(void)
{
80105dc0:	55                   	push   %ebp
80105dc1:	89 e5                	mov    %esp,%ebp
80105dc3:	83 ec 1c             	sub    $0x1c,%esp
  char *thread;
  char *start_routine;
  char *arg;

  if (argptr(0, &thread, sizeof(thread_t*)) < 0) 
80105dc6:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105dc9:	6a 04                	push   $0x4
80105dcb:	50                   	push   %eax
80105dcc:	6a 00                	push   $0x0
80105dce:	e8 ad f0 ff ff       	call   80104e80 <argptr>
80105dd3:	83 c4 10             	add    $0x10,%esp
80105dd6:	85 c0                	test   %eax,%eax
80105dd8:	78 46                	js     80105e20 <sys_thread_create+0x60>
    return -1;
  if (argptr(1, &start_routine, sizeof(void*(*)(void*))) < 0)
80105dda:	83 ec 04             	sub    $0x4,%esp
80105ddd:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105de0:	6a 04                	push   $0x4
80105de2:	50                   	push   %eax
80105de3:	6a 01                	push   $0x1
80105de5:	e8 96 f0 ff ff       	call   80104e80 <argptr>
80105dea:	83 c4 10             	add    $0x10,%esp
80105ded:	85 c0                	test   %eax,%eax
80105def:	78 2f                	js     80105e20 <sys_thread_create+0x60>
    return -1;
  if (argptr(2, &arg, sizeof(void*)) < 0) 
80105df1:	83 ec 04             	sub    $0x4,%esp
80105df4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105df7:	6a 04                	push   $0x4
80105df9:	50                   	push   %eax
80105dfa:	6a 02                	push   $0x2
80105dfc:	e8 7f f0 ff ff       	call   80104e80 <argptr>
80105e01:	83 c4 10             	add    $0x10,%esp
80105e04:	85 c0                	test   %eax,%eax
80105e06:	78 18                	js     80105e20 <sys_thread_create+0x60>
    return -1;
  return thread_create((thread_t*)thread, (void*(*)(void*))start_routine, (void*)arg);
80105e08:	83 ec 04             	sub    $0x4,%esp
80105e0b:	ff 75 f4             	push   -0xc(%ebp)
80105e0e:	ff 75 f0             	push   -0x10(%ebp)
80105e11:	ff 75 ec             	push   -0x14(%ebp)
80105e14:	e8 67 e5 ff ff       	call   80104380 <thread_create>
80105e19:	83 c4 10             	add    $0x10,%esp
}
80105e1c:	c9                   	leave  
80105e1d:	c3                   	ret    
80105e1e:	66 90                	xchg   %ax,%ax
80105e20:	c9                   	leave  
    return -1;
80105e21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e26:	c3                   	ret    
80105e27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e2e:	66 90                	xchg   %ax,%ax

80105e30 <sys_thread_exit>:

int 
sys_thread_exit(void)
{
80105e30:	55                   	push   %ebp
80105e31:	89 e5                	mov    %esp,%ebp
80105e33:	83 ec 1c             	sub    $0x1c,%esp
  char *retval;
  if (argptr(0, &retval, sizeof(void*)) < 0)
80105e36:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e39:	6a 04                	push   $0x4
80105e3b:	50                   	push   %eax
80105e3c:	6a 00                	push   $0x0
80105e3e:	e8 3d f0 ff ff       	call   80104e80 <argptr>
80105e43:	83 c4 10             	add    $0x10,%esp
80105e46:	85 c0                	test   %eax,%eax
80105e48:	78 16                	js     80105e60 <sys_thread_exit+0x30>
    return -1;
  thread_exit((void*)retval);
80105e4a:	83 ec 0c             	sub    $0xc,%esp
80105e4d:	ff 75 f4             	push   -0xc(%ebp)
80105e50:	e8 9b e6 ff ff       	call   801044f0 <thread_exit>
  return 0;
80105e55:	83 c4 10             	add    $0x10,%esp
80105e58:	31 c0                	xor    %eax,%eax
}
80105e5a:	c9                   	leave  
80105e5b:	c3                   	ret    
80105e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e60:	c9                   	leave  
    return -1;
80105e61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e66:	c3                   	ret    
80105e67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e6e:	66 90                	xchg   %ax,%ax

80105e70 <sys_thread_join>:

int
sys_thread_join(void)
{
80105e70:	55                   	push   %ebp
80105e71:	89 e5                	mov    %esp,%ebp
80105e73:	83 ec 20             	sub    $0x20,%esp
  int thread;
  char *retval;
  if (argint(0, &thread) < 0)
80105e76:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e79:	50                   	push   %eax
80105e7a:	6a 00                	push   $0x0
80105e7c:	e8 af ef ff ff       	call   80104e30 <argint>
80105e81:	83 c4 10             	add    $0x10,%esp
80105e84:	85 c0                	test   %eax,%eax
80105e86:	78 30                	js     80105eb8 <sys_thread_join+0x48>
    return -1;
  if (argptr(1, &retval, sizeof(void**)) < 0)
80105e88:	83 ec 04             	sub    $0x4,%esp
80105e8b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e8e:	6a 04                	push   $0x4
80105e90:	50                   	push   %eax
80105e91:	6a 01                	push   $0x1
80105e93:	e8 e8 ef ff ff       	call   80104e80 <argptr>
80105e98:	83 c4 10             	add    $0x10,%esp
80105e9b:	85 c0                	test   %eax,%eax
80105e9d:	78 19                	js     80105eb8 <sys_thread_join+0x48>
    return -1;
  return thread_join((thread_t)thread, (void**)retval);
80105e9f:	83 ec 08             	sub    $0x8,%esp
80105ea2:	ff 75 f4             	push   -0xc(%ebp)
80105ea5:	ff 75 f0             	push   -0x10(%ebp)
80105ea8:	e8 43 e7 ff ff       	call   801045f0 <thread_join>
80105ead:	83 c4 10             	add    $0x10,%esp
80105eb0:	c9                   	leave  
80105eb1:	c3                   	ret    
80105eb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105eb8:	c9                   	leave  
    return -1;
80105eb9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ebe:	c3                   	ret    

80105ebf <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105ebf:	1e                   	push   %ds
  pushl %es
80105ec0:	06                   	push   %es
  pushl %fs
80105ec1:	0f a0                	push   %fs
  pushl %gs
80105ec3:	0f a8                	push   %gs
  pushal
80105ec5:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105ec6:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105eca:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105ecc:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105ece:	54                   	push   %esp
  call trap
80105ecf:	e8 cc 00 00 00       	call   80105fa0 <trap>
  addl $4, %esp
80105ed4:	83 c4 04             	add    $0x4,%esp

80105ed7 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105ed7:	61                   	popa   
  popl %gs
80105ed8:	0f a9                	pop    %gs
  popl %fs
80105eda:	0f a1                	pop    %fs
  popl %es
80105edc:	07                   	pop    %es
  popl %ds
80105edd:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105ede:	83 c4 08             	add    $0x8,%esp
  iret
80105ee1:	cf                   	iret   
80105ee2:	66 90                	xchg   %ax,%ax
80105ee4:	66 90                	xchg   %ax,%ax
80105ee6:	66 90                	xchg   %ax,%ax
80105ee8:	66 90                	xchg   %ax,%ax
80105eea:	66 90                	xchg   %ax,%ax
80105eec:	66 90                	xchg   %ax,%ax
80105eee:	66 90                	xchg   %ax,%ax

80105ef0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105ef0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105ef1:	31 c0                	xor    %eax,%eax
{
80105ef3:	89 e5                	mov    %esp,%ebp
80105ef5:	83 ec 08             	sub    $0x8,%esp
80105ef8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105eff:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105f00:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105f07:	c7 04 c5 c2 50 11 80 	movl   $0x8e000008,-0x7feeaf3e(,%eax,8)
80105f0e:	08 00 00 8e 
80105f12:	66 89 14 c5 c0 50 11 	mov    %dx,-0x7feeaf40(,%eax,8)
80105f19:	80 
80105f1a:	c1 ea 10             	shr    $0x10,%edx
80105f1d:	66 89 14 c5 c6 50 11 	mov    %dx,-0x7feeaf3a(,%eax,8)
80105f24:	80 
  for(i = 0; i < 256; i++)
80105f25:	83 c0 01             	add    $0x1,%eax
80105f28:	3d 00 01 00 00       	cmp    $0x100,%eax
80105f2d:	75 d1                	jne    80105f00 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105f2f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105f32:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105f37:	c7 05 c2 52 11 80 08 	movl   $0xef000008,0x801152c2
80105f3e:	00 00 ef 
  initlock(&tickslock, "time");
80105f41:	68 25 80 10 80       	push   $0x80108025
80105f46:	68 80 50 11 80       	push   $0x80115080
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105f4b:	66 a3 c0 52 11 80    	mov    %ax,0x801152c0
80105f51:	c1 e8 10             	shr    $0x10,%eax
80105f54:	66 a3 c6 52 11 80    	mov    %ax,0x801152c6
  initlock(&tickslock, "time");
80105f5a:	e8 71 e9 ff ff       	call   801048d0 <initlock>
}
80105f5f:	83 c4 10             	add    $0x10,%esp
80105f62:	c9                   	leave  
80105f63:	c3                   	ret    
80105f64:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f6f:	90                   	nop

80105f70 <idtinit>:

void
idtinit(void)
{
80105f70:	55                   	push   %ebp
  pd[0] = size-1;
80105f71:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105f76:	89 e5                	mov    %esp,%ebp
80105f78:	83 ec 10             	sub    $0x10,%esp
80105f7b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105f7f:	b8 c0 50 11 80       	mov    $0x801150c0,%eax
80105f84:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105f88:	c1 e8 10             	shr    $0x10,%eax
80105f8b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105f8f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105f92:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105f95:	c9                   	leave  
80105f96:	c3                   	ret    
80105f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f9e:	66 90                	xchg   %ax,%ax

80105fa0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105fa0:	55                   	push   %ebp
80105fa1:	89 e5                	mov    %esp,%ebp
80105fa3:	57                   	push   %edi
80105fa4:	56                   	push   %esi
80105fa5:	53                   	push   %ebx
80105fa6:	83 ec 1c             	sub    $0x1c,%esp
80105fa9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105fac:	8b 43 30             	mov    0x30(%ebx),%eax
80105faf:	83 f8 40             	cmp    $0x40,%eax
80105fb2:	0f 84 68 01 00 00    	je     80106120 <trap+0x180>
      else thread_exit(0);
    }
    return;
  }

  switch(tf->trapno){
80105fb8:	83 e8 20             	sub    $0x20,%eax
80105fbb:	83 f8 1f             	cmp    $0x1f,%eax
80105fbe:	0f 87 8c 00 00 00    	ja     80106050 <trap+0xb0>
80105fc4:	ff 24 85 cc 80 10 80 	jmp    *-0x7fef7f34(,%eax,4)
80105fcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105fcf:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105fd0:	e8 8b c2 ff ff       	call   80102260 <ideintr>
    lapiceoi();
80105fd5:	e8 56 c9 ff ff       	call   80102930 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER){
80105fda:	e8 31 da ff ff       	call   80103a10 <myproc>
80105fdf:	85 c0                	test   %eax,%eax
80105fe1:	74 1d                	je     80106000 <trap+0x60>
80105fe3:	e8 28 da ff ff       	call   80103a10 <myproc>
80105fe8:	8b 50 24             	mov    0x24(%eax),%edx
80105feb:	85 d2                	test   %edx,%edx
80105fed:	74 11                	je     80106000 <trap+0x60>
80105fef:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105ff3:	83 e0 03             	and    $0x3,%eax
80105ff6:	66 83 f8 03          	cmp    $0x3,%ax
80105ffa:	0f 84 00 02 00 00    	je     80106200 <trap+0x260>
    else thread_exit(0);
  }

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106000:	e8 0b da ff ff       	call   80103a10 <myproc>
80106005:	85 c0                	test   %eax,%eax
80106007:	74 0f                	je     80106018 <trap+0x78>
80106009:	e8 02 da ff ff       	call   80103a10 <myproc>
8010600e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106012:	0f 84 b8 00 00 00    	je     801060d0 <trap+0x130>
      // procdump();
      yield();
    }

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER){
80106018:	e8 f3 d9 ff ff       	call   80103a10 <myproc>
8010601d:	85 c0                	test   %eax,%eax
8010601f:	74 1d                	je     8010603e <trap+0x9e>
80106021:	e8 ea d9 ff ff       	call   80103a10 <myproc>
80106026:	8b 40 24             	mov    0x24(%eax),%eax
80106029:	85 c0                	test   %eax,%eax
8010602b:	74 11                	je     8010603e <trap+0x9e>
8010602d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106031:	83 e0 03             	and    $0x3,%eax
80106034:	66 83 f8 03          	cmp    $0x3,%ax
80106038:	0f 84 0f 01 00 00    	je     8010614d <trap+0x1ad>
    if (myproc()->tid <= 1) exit();
    else thread_exit(0);
  }

}
8010603e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106041:	5b                   	pop    %ebx
80106042:	5e                   	pop    %esi
80106043:	5f                   	pop    %edi
80106044:	5d                   	pop    %ebp
80106045:	c3                   	ret    
80106046:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010604d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80106050:	e8 bb d9 ff ff       	call   80103a10 <myproc>
80106055:	8b 7b 38             	mov    0x38(%ebx),%edi
80106058:	85 c0                	test   %eax,%eax
8010605a:	0f 84 0a 02 00 00    	je     8010626a <trap+0x2ca>
80106060:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106064:	0f 84 00 02 00 00    	je     8010626a <trap+0x2ca>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010606a:	0f 20 d1             	mov    %cr2,%ecx
8010606d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106070:	e8 7b d9 ff ff       	call   801039f0 <cpuid>
80106075:	8b 73 30             	mov    0x30(%ebx),%esi
80106078:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010607b:	8b 43 34             	mov    0x34(%ebx),%eax
8010607e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80106081:	e8 8a d9 ff ff       	call   80103a10 <myproc>
80106086:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106089:	e8 82 d9 ff ff       	call   80103a10 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010608e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106091:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106094:	51                   	push   %ecx
80106095:	57                   	push   %edi
80106096:	52                   	push   %edx
80106097:	ff 75 e4             	push   -0x1c(%ebp)
8010609a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010609b:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010609e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801060a1:	56                   	push   %esi
801060a2:	ff 70 10             	push   0x10(%eax)
801060a5:	68 88 80 10 80       	push   $0x80108088
801060aa:	e8 f1 a5 ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
801060af:	83 c4 20             	add    $0x20,%esp
801060b2:	e8 59 d9 ff ff       	call   80103a10 <myproc>
801060b7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER){
801060be:	e8 4d d9 ff ff       	call   80103a10 <myproc>
801060c3:	85 c0                	test   %eax,%eax
801060c5:	0f 85 18 ff ff ff    	jne    80105fe3 <trap+0x43>
801060cb:	e9 30 ff ff ff       	jmp    80106000 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
801060d0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801060d4:	0f 85 3e ff ff ff    	jne    80106018 <trap+0x78>
      yield();
801060da:	e8 d1 df ff ff       	call   801040b0 <yield>
801060df:	e9 34 ff ff ff       	jmp    80106018 <trap+0x78>
801060e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801060e8:	8b 7b 38             	mov    0x38(%ebx),%edi
801060eb:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801060ef:	e8 fc d8 ff ff       	call   801039f0 <cpuid>
801060f4:	57                   	push   %edi
801060f5:	56                   	push   %esi
801060f6:	50                   	push   %eax
801060f7:	68 30 80 10 80       	push   $0x80108030
801060fc:	e8 9f a5 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80106101:	e8 2a c8 ff ff       	call   80102930 <lapiceoi>
    break;
80106106:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER){
80106109:	e8 02 d9 ff ff       	call   80103a10 <myproc>
8010610e:	85 c0                	test   %eax,%eax
80106110:	0f 85 cd fe ff ff    	jne    80105fe3 <trap+0x43>
80106116:	e9 e5 fe ff ff       	jmp    80106000 <trap+0x60>
8010611b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010611f:	90                   	nop
    if(myproc()->killed){
80106120:	e8 eb d8 ff ff       	call   80103a10 <myproc>
80106125:	8b 70 24             	mov    0x24(%eax),%esi
80106128:	85 f6                	test   %esi,%esi
8010612a:	0f 85 f0 00 00 00    	jne    80106220 <trap+0x280>
    myproc()->tf = tf;
80106130:	e8 db d8 ff ff       	call   80103a10 <myproc>
80106135:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106138:	e8 53 ee ff ff       	call   80104f90 <syscall>
    if(myproc()->killed){
8010613d:	e8 ce d8 ff ff       	call   80103a10 <myproc>
80106142:	8b 48 24             	mov    0x24(%eax),%ecx
80106145:	85 c9                	test   %ecx,%ecx
80106147:	0f 84 f1 fe ff ff    	je     8010603e <trap+0x9e>
      if(myproc()->tid <= 1) exit();
8010614d:	e8 be d8 ff ff       	call   80103a10 <myproc>
80106152:	83 b8 80 00 00 00 01 	cmpl   $0x1,0x80(%eax)
80106159:	0f 8e e1 00 00 00    	jle    80106240 <trap+0x2a0>
      else thread_exit(0);
8010615f:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
}
80106166:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106169:	5b                   	pop    %ebx
8010616a:	5e                   	pop    %esi
8010616b:	5f                   	pop    %edi
8010616c:	5d                   	pop    %ebp
      else thread_exit(0);
8010616d:	e9 7e e3 ff ff       	jmp    801044f0 <thread_exit>
80106172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    uartintr();
80106178:	e8 93 02 00 00       	call   80106410 <uartintr>
    lapiceoi();
8010617d:	e8 ae c7 ff ff       	call   80102930 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER){
80106182:	e8 89 d8 ff ff       	call   80103a10 <myproc>
80106187:	85 c0                	test   %eax,%eax
80106189:	0f 85 54 fe ff ff    	jne    80105fe3 <trap+0x43>
8010618f:	e9 6c fe ff ff       	jmp    80106000 <trap+0x60>
80106194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106198:	e8 53 c6 ff ff       	call   801027f0 <kbdintr>
    lapiceoi();
8010619d:	e8 8e c7 ff ff       	call   80102930 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER){
801061a2:	e8 69 d8 ff ff       	call   80103a10 <myproc>
801061a7:	85 c0                	test   %eax,%eax
801061a9:	0f 85 34 fe ff ff    	jne    80105fe3 <trap+0x43>
801061af:	e9 4c fe ff ff       	jmp    80106000 <trap+0x60>
801061b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
801061b8:	e8 33 d8 ff ff       	call   801039f0 <cpuid>
801061bd:	85 c0                	test   %eax,%eax
801061bf:	0f 85 10 fe ff ff    	jne    80105fd5 <trap+0x35>
      acquire(&tickslock);
801061c5:	83 ec 0c             	sub    $0xc,%esp
801061c8:	68 80 50 11 80       	push   $0x80115080
801061cd:	e8 ce e8 ff ff       	call   80104aa0 <acquire>
      wakeup(&ticks);
801061d2:	c7 04 24 60 50 11 80 	movl   $0x80115060,(%esp)
      ticks++;
801061d9:	83 05 60 50 11 80 01 	addl   $0x1,0x80115060
      wakeup(&ticks);
801061e0:	e8 db df ff ff       	call   801041c0 <wakeup>
      release(&tickslock);
801061e5:	c7 04 24 80 50 11 80 	movl   $0x80115080,(%esp)
801061ec:	e8 4f e8 ff ff       	call   80104a40 <release>
801061f1:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801061f4:	e9 dc fd ff ff       	jmp    80105fd5 <trap+0x35>
801061f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (myproc()->tid <= 1) exit();
80106200:	e8 0b d8 ff ff       	call   80103a10 <myproc>
80106205:	83 b8 80 00 00 00 01 	cmpl   $0x1,0x80(%eax)
8010620c:	7e 42                	jle    80106250 <trap+0x2b0>
    else thread_exit(0);
8010620e:	83 ec 0c             	sub    $0xc,%esp
80106211:	6a 00                	push   $0x0
80106213:	e8 d8 e2 ff ff       	call   801044f0 <thread_exit>
80106218:	83 c4 10             	add    $0x10,%esp
8010621b:	e9 e0 fd ff ff       	jmp    80106000 <trap+0x60>
      if(myproc()->tid <= 1) exit();
80106220:	e8 eb d7 ff ff       	call   80103a10 <myproc>
80106225:	83 b8 80 00 00 00 01 	cmpl   $0x1,0x80(%eax)
8010622c:	7e 32                	jle    80106260 <trap+0x2c0>
      else thread_exit(0);
8010622e:	83 ec 0c             	sub    $0xc,%esp
80106231:	6a 00                	push   $0x0
80106233:	e8 b8 e2 ff ff       	call   801044f0 <thread_exit>
80106238:	83 c4 10             	add    $0x10,%esp
8010623b:	e9 f0 fe ff ff       	jmp    80106130 <trap+0x190>
}
80106240:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106243:	5b                   	pop    %ebx
80106244:	5e                   	pop    %esi
80106245:	5f                   	pop    %edi
80106246:	5d                   	pop    %ebp
      if(myproc()->tid <= 1) exit();
80106247:	e9 04 dc ff ff       	jmp    80103e50 <exit>
8010624c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (myproc()->tid <= 1) exit();
80106250:	e8 fb db ff ff       	call   80103e50 <exit>
80106255:	e9 a6 fd ff ff       	jmp    80106000 <trap+0x60>
8010625a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(myproc()->tid <= 1) exit();
80106260:	e8 eb db ff ff       	call   80103e50 <exit>
80106265:	e9 c6 fe ff ff       	jmp    80106130 <trap+0x190>
8010626a:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010626d:	e8 7e d7 ff ff       	call   801039f0 <cpuid>
80106272:	83 ec 0c             	sub    $0xc,%esp
80106275:	56                   	push   %esi
80106276:	57                   	push   %edi
80106277:	50                   	push   %eax
80106278:	ff 73 30             	push   0x30(%ebx)
8010627b:	68 54 80 10 80       	push   $0x80108054
80106280:	e8 1b a4 ff ff       	call   801006a0 <cprintf>
      panic("trap");
80106285:	83 c4 14             	add    $0x14,%esp
80106288:	68 2a 80 10 80       	push   $0x8010802a
8010628d:	e8 ee a0 ff ff       	call   80100380 <panic>
80106292:	66 90                	xchg   %ax,%ax
80106294:	66 90                	xchg   %ax,%ax
80106296:	66 90                	xchg   %ax,%ax
80106298:	66 90                	xchg   %ax,%ax
8010629a:	66 90                	xchg   %ax,%ax
8010629c:	66 90                	xchg   %ax,%ax
8010629e:	66 90                	xchg   %ax,%ax

801062a0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801062a0:	a1 c0 58 11 80       	mov    0x801158c0,%eax
801062a5:	85 c0                	test   %eax,%eax
801062a7:	74 17                	je     801062c0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801062a9:	ba fd 03 00 00       	mov    $0x3fd,%edx
801062ae:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801062af:	a8 01                	test   $0x1,%al
801062b1:	74 0d                	je     801062c0 <uartgetc+0x20>
801062b3:	ba f8 03 00 00       	mov    $0x3f8,%edx
801062b8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801062b9:	0f b6 c0             	movzbl %al,%eax
801062bc:	c3                   	ret    
801062bd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801062c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801062c5:	c3                   	ret    
801062c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062cd:	8d 76 00             	lea    0x0(%esi),%esi

801062d0 <uartinit>:
{
801062d0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801062d1:	31 c9                	xor    %ecx,%ecx
801062d3:	89 c8                	mov    %ecx,%eax
801062d5:	89 e5                	mov    %esp,%ebp
801062d7:	57                   	push   %edi
801062d8:	bf fa 03 00 00       	mov    $0x3fa,%edi
801062dd:	56                   	push   %esi
801062de:	89 fa                	mov    %edi,%edx
801062e0:	53                   	push   %ebx
801062e1:	83 ec 1c             	sub    $0x1c,%esp
801062e4:	ee                   	out    %al,(%dx)
801062e5:	be fb 03 00 00       	mov    $0x3fb,%esi
801062ea:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801062ef:	89 f2                	mov    %esi,%edx
801062f1:	ee                   	out    %al,(%dx)
801062f2:	b8 0c 00 00 00       	mov    $0xc,%eax
801062f7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801062fc:	ee                   	out    %al,(%dx)
801062fd:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106302:	89 c8                	mov    %ecx,%eax
80106304:	89 da                	mov    %ebx,%edx
80106306:	ee                   	out    %al,(%dx)
80106307:	b8 03 00 00 00       	mov    $0x3,%eax
8010630c:	89 f2                	mov    %esi,%edx
8010630e:	ee                   	out    %al,(%dx)
8010630f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106314:	89 c8                	mov    %ecx,%eax
80106316:	ee                   	out    %al,(%dx)
80106317:	b8 01 00 00 00       	mov    $0x1,%eax
8010631c:	89 da                	mov    %ebx,%edx
8010631e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010631f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106324:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106325:	3c ff                	cmp    $0xff,%al
80106327:	74 78                	je     801063a1 <uartinit+0xd1>
  uart = 1;
80106329:	c7 05 c0 58 11 80 01 	movl   $0x1,0x801158c0
80106330:	00 00 00 
80106333:	89 fa                	mov    %edi,%edx
80106335:	ec                   	in     (%dx),%al
80106336:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010633b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010633c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010633f:	bf 4c 81 10 80       	mov    $0x8010814c,%edi
80106344:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80106349:	6a 00                	push   $0x0
8010634b:	6a 04                	push   $0x4
8010634d:	e8 4e c1 ff ff       	call   801024a0 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106352:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80106356:	83 c4 10             	add    $0x10,%esp
80106359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80106360:	a1 c0 58 11 80       	mov    0x801158c0,%eax
80106365:	bb 80 00 00 00       	mov    $0x80,%ebx
8010636a:	85 c0                	test   %eax,%eax
8010636c:	75 14                	jne    80106382 <uartinit+0xb2>
8010636e:	eb 23                	jmp    80106393 <uartinit+0xc3>
    microdelay(10);
80106370:	83 ec 0c             	sub    $0xc,%esp
80106373:	6a 0a                	push   $0xa
80106375:	e8 d6 c5 ff ff       	call   80102950 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010637a:	83 c4 10             	add    $0x10,%esp
8010637d:	83 eb 01             	sub    $0x1,%ebx
80106380:	74 07                	je     80106389 <uartinit+0xb9>
80106382:	89 f2                	mov    %esi,%edx
80106384:	ec                   	in     (%dx),%al
80106385:	a8 20                	test   $0x20,%al
80106387:	74 e7                	je     80106370 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106389:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010638d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106392:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80106393:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80106397:	83 c7 01             	add    $0x1,%edi
8010639a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010639d:	84 c0                	test   %al,%al
8010639f:	75 bf                	jne    80106360 <uartinit+0x90>
}
801063a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063a4:	5b                   	pop    %ebx
801063a5:	5e                   	pop    %esi
801063a6:	5f                   	pop    %edi
801063a7:	5d                   	pop    %ebp
801063a8:	c3                   	ret    
801063a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801063b0 <uartputc>:
  if(!uart)
801063b0:	a1 c0 58 11 80       	mov    0x801158c0,%eax
801063b5:	85 c0                	test   %eax,%eax
801063b7:	74 47                	je     80106400 <uartputc+0x50>
{
801063b9:	55                   	push   %ebp
801063ba:	89 e5                	mov    %esp,%ebp
801063bc:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801063bd:	be fd 03 00 00       	mov    $0x3fd,%esi
801063c2:	53                   	push   %ebx
801063c3:	bb 80 00 00 00       	mov    $0x80,%ebx
801063c8:	eb 18                	jmp    801063e2 <uartputc+0x32>
801063ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
801063d0:	83 ec 0c             	sub    $0xc,%esp
801063d3:	6a 0a                	push   $0xa
801063d5:	e8 76 c5 ff ff       	call   80102950 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801063da:	83 c4 10             	add    $0x10,%esp
801063dd:	83 eb 01             	sub    $0x1,%ebx
801063e0:	74 07                	je     801063e9 <uartputc+0x39>
801063e2:	89 f2                	mov    %esi,%edx
801063e4:	ec                   	in     (%dx),%al
801063e5:	a8 20                	test   $0x20,%al
801063e7:	74 e7                	je     801063d0 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801063e9:	8b 45 08             	mov    0x8(%ebp),%eax
801063ec:	ba f8 03 00 00       	mov    $0x3f8,%edx
801063f1:	ee                   	out    %al,(%dx)
}
801063f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801063f5:	5b                   	pop    %ebx
801063f6:	5e                   	pop    %esi
801063f7:	5d                   	pop    %ebp
801063f8:	c3                   	ret    
801063f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106400:	c3                   	ret    
80106401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106408:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010640f:	90                   	nop

80106410 <uartintr>:

void
uartintr(void)
{
80106410:	55                   	push   %ebp
80106411:	89 e5                	mov    %esp,%ebp
80106413:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106416:	68 a0 62 10 80       	push   $0x801062a0
8010641b:	e8 60 a4 ff ff       	call   80100880 <consoleintr>
}
80106420:	83 c4 10             	add    $0x10,%esp
80106423:	c9                   	leave  
80106424:	c3                   	ret    

80106425 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106425:	6a 00                	push   $0x0
  pushl $0
80106427:	6a 00                	push   $0x0
  jmp alltraps
80106429:	e9 91 fa ff ff       	jmp    80105ebf <alltraps>

8010642e <vector1>:
.globl vector1
vector1:
  pushl $0
8010642e:	6a 00                	push   $0x0
  pushl $1
80106430:	6a 01                	push   $0x1
  jmp alltraps
80106432:	e9 88 fa ff ff       	jmp    80105ebf <alltraps>

80106437 <vector2>:
.globl vector2
vector2:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $2
80106439:	6a 02                	push   $0x2
  jmp alltraps
8010643b:	e9 7f fa ff ff       	jmp    80105ebf <alltraps>

80106440 <vector3>:
.globl vector3
vector3:
  pushl $0
80106440:	6a 00                	push   $0x0
  pushl $3
80106442:	6a 03                	push   $0x3
  jmp alltraps
80106444:	e9 76 fa ff ff       	jmp    80105ebf <alltraps>

80106449 <vector4>:
.globl vector4
vector4:
  pushl $0
80106449:	6a 00                	push   $0x0
  pushl $4
8010644b:	6a 04                	push   $0x4
  jmp alltraps
8010644d:	e9 6d fa ff ff       	jmp    80105ebf <alltraps>

80106452 <vector5>:
.globl vector5
vector5:
  pushl $0
80106452:	6a 00                	push   $0x0
  pushl $5
80106454:	6a 05                	push   $0x5
  jmp alltraps
80106456:	e9 64 fa ff ff       	jmp    80105ebf <alltraps>

8010645b <vector6>:
.globl vector6
vector6:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $6
8010645d:	6a 06                	push   $0x6
  jmp alltraps
8010645f:	e9 5b fa ff ff       	jmp    80105ebf <alltraps>

80106464 <vector7>:
.globl vector7
vector7:
  pushl $0
80106464:	6a 00                	push   $0x0
  pushl $7
80106466:	6a 07                	push   $0x7
  jmp alltraps
80106468:	e9 52 fa ff ff       	jmp    80105ebf <alltraps>

8010646d <vector8>:
.globl vector8
vector8:
  pushl $8
8010646d:	6a 08                	push   $0x8
  jmp alltraps
8010646f:	e9 4b fa ff ff       	jmp    80105ebf <alltraps>

80106474 <vector9>:
.globl vector9
vector9:
  pushl $0
80106474:	6a 00                	push   $0x0
  pushl $9
80106476:	6a 09                	push   $0x9
  jmp alltraps
80106478:	e9 42 fa ff ff       	jmp    80105ebf <alltraps>

8010647d <vector10>:
.globl vector10
vector10:
  pushl $10
8010647d:	6a 0a                	push   $0xa
  jmp alltraps
8010647f:	e9 3b fa ff ff       	jmp    80105ebf <alltraps>

80106484 <vector11>:
.globl vector11
vector11:
  pushl $11
80106484:	6a 0b                	push   $0xb
  jmp alltraps
80106486:	e9 34 fa ff ff       	jmp    80105ebf <alltraps>

8010648b <vector12>:
.globl vector12
vector12:
  pushl $12
8010648b:	6a 0c                	push   $0xc
  jmp alltraps
8010648d:	e9 2d fa ff ff       	jmp    80105ebf <alltraps>

80106492 <vector13>:
.globl vector13
vector13:
  pushl $13
80106492:	6a 0d                	push   $0xd
  jmp alltraps
80106494:	e9 26 fa ff ff       	jmp    80105ebf <alltraps>

80106499 <vector14>:
.globl vector14
vector14:
  pushl $14
80106499:	6a 0e                	push   $0xe
  jmp alltraps
8010649b:	e9 1f fa ff ff       	jmp    80105ebf <alltraps>

801064a0 <vector15>:
.globl vector15
vector15:
  pushl $0
801064a0:	6a 00                	push   $0x0
  pushl $15
801064a2:	6a 0f                	push   $0xf
  jmp alltraps
801064a4:	e9 16 fa ff ff       	jmp    80105ebf <alltraps>

801064a9 <vector16>:
.globl vector16
vector16:
  pushl $0
801064a9:	6a 00                	push   $0x0
  pushl $16
801064ab:	6a 10                	push   $0x10
  jmp alltraps
801064ad:	e9 0d fa ff ff       	jmp    80105ebf <alltraps>

801064b2 <vector17>:
.globl vector17
vector17:
  pushl $17
801064b2:	6a 11                	push   $0x11
  jmp alltraps
801064b4:	e9 06 fa ff ff       	jmp    80105ebf <alltraps>

801064b9 <vector18>:
.globl vector18
vector18:
  pushl $0
801064b9:	6a 00                	push   $0x0
  pushl $18
801064bb:	6a 12                	push   $0x12
  jmp alltraps
801064bd:	e9 fd f9 ff ff       	jmp    80105ebf <alltraps>

801064c2 <vector19>:
.globl vector19
vector19:
  pushl $0
801064c2:	6a 00                	push   $0x0
  pushl $19
801064c4:	6a 13                	push   $0x13
  jmp alltraps
801064c6:	e9 f4 f9 ff ff       	jmp    80105ebf <alltraps>

801064cb <vector20>:
.globl vector20
vector20:
  pushl $0
801064cb:	6a 00                	push   $0x0
  pushl $20
801064cd:	6a 14                	push   $0x14
  jmp alltraps
801064cf:	e9 eb f9 ff ff       	jmp    80105ebf <alltraps>

801064d4 <vector21>:
.globl vector21
vector21:
  pushl $0
801064d4:	6a 00                	push   $0x0
  pushl $21
801064d6:	6a 15                	push   $0x15
  jmp alltraps
801064d8:	e9 e2 f9 ff ff       	jmp    80105ebf <alltraps>

801064dd <vector22>:
.globl vector22
vector22:
  pushl $0
801064dd:	6a 00                	push   $0x0
  pushl $22
801064df:	6a 16                	push   $0x16
  jmp alltraps
801064e1:	e9 d9 f9 ff ff       	jmp    80105ebf <alltraps>

801064e6 <vector23>:
.globl vector23
vector23:
  pushl $0
801064e6:	6a 00                	push   $0x0
  pushl $23
801064e8:	6a 17                	push   $0x17
  jmp alltraps
801064ea:	e9 d0 f9 ff ff       	jmp    80105ebf <alltraps>

801064ef <vector24>:
.globl vector24
vector24:
  pushl $0
801064ef:	6a 00                	push   $0x0
  pushl $24
801064f1:	6a 18                	push   $0x18
  jmp alltraps
801064f3:	e9 c7 f9 ff ff       	jmp    80105ebf <alltraps>

801064f8 <vector25>:
.globl vector25
vector25:
  pushl $0
801064f8:	6a 00                	push   $0x0
  pushl $25
801064fa:	6a 19                	push   $0x19
  jmp alltraps
801064fc:	e9 be f9 ff ff       	jmp    80105ebf <alltraps>

80106501 <vector26>:
.globl vector26
vector26:
  pushl $0
80106501:	6a 00                	push   $0x0
  pushl $26
80106503:	6a 1a                	push   $0x1a
  jmp alltraps
80106505:	e9 b5 f9 ff ff       	jmp    80105ebf <alltraps>

8010650a <vector27>:
.globl vector27
vector27:
  pushl $0
8010650a:	6a 00                	push   $0x0
  pushl $27
8010650c:	6a 1b                	push   $0x1b
  jmp alltraps
8010650e:	e9 ac f9 ff ff       	jmp    80105ebf <alltraps>

80106513 <vector28>:
.globl vector28
vector28:
  pushl $0
80106513:	6a 00                	push   $0x0
  pushl $28
80106515:	6a 1c                	push   $0x1c
  jmp alltraps
80106517:	e9 a3 f9 ff ff       	jmp    80105ebf <alltraps>

8010651c <vector29>:
.globl vector29
vector29:
  pushl $0
8010651c:	6a 00                	push   $0x0
  pushl $29
8010651e:	6a 1d                	push   $0x1d
  jmp alltraps
80106520:	e9 9a f9 ff ff       	jmp    80105ebf <alltraps>

80106525 <vector30>:
.globl vector30
vector30:
  pushl $0
80106525:	6a 00                	push   $0x0
  pushl $30
80106527:	6a 1e                	push   $0x1e
  jmp alltraps
80106529:	e9 91 f9 ff ff       	jmp    80105ebf <alltraps>

8010652e <vector31>:
.globl vector31
vector31:
  pushl $0
8010652e:	6a 00                	push   $0x0
  pushl $31
80106530:	6a 1f                	push   $0x1f
  jmp alltraps
80106532:	e9 88 f9 ff ff       	jmp    80105ebf <alltraps>

80106537 <vector32>:
.globl vector32
vector32:
  pushl $0
80106537:	6a 00                	push   $0x0
  pushl $32
80106539:	6a 20                	push   $0x20
  jmp alltraps
8010653b:	e9 7f f9 ff ff       	jmp    80105ebf <alltraps>

80106540 <vector33>:
.globl vector33
vector33:
  pushl $0
80106540:	6a 00                	push   $0x0
  pushl $33
80106542:	6a 21                	push   $0x21
  jmp alltraps
80106544:	e9 76 f9 ff ff       	jmp    80105ebf <alltraps>

80106549 <vector34>:
.globl vector34
vector34:
  pushl $0
80106549:	6a 00                	push   $0x0
  pushl $34
8010654b:	6a 22                	push   $0x22
  jmp alltraps
8010654d:	e9 6d f9 ff ff       	jmp    80105ebf <alltraps>

80106552 <vector35>:
.globl vector35
vector35:
  pushl $0
80106552:	6a 00                	push   $0x0
  pushl $35
80106554:	6a 23                	push   $0x23
  jmp alltraps
80106556:	e9 64 f9 ff ff       	jmp    80105ebf <alltraps>

8010655b <vector36>:
.globl vector36
vector36:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $36
8010655d:	6a 24                	push   $0x24
  jmp alltraps
8010655f:	e9 5b f9 ff ff       	jmp    80105ebf <alltraps>

80106564 <vector37>:
.globl vector37
vector37:
  pushl $0
80106564:	6a 00                	push   $0x0
  pushl $37
80106566:	6a 25                	push   $0x25
  jmp alltraps
80106568:	e9 52 f9 ff ff       	jmp    80105ebf <alltraps>

8010656d <vector38>:
.globl vector38
vector38:
  pushl $0
8010656d:	6a 00                	push   $0x0
  pushl $38
8010656f:	6a 26                	push   $0x26
  jmp alltraps
80106571:	e9 49 f9 ff ff       	jmp    80105ebf <alltraps>

80106576 <vector39>:
.globl vector39
vector39:
  pushl $0
80106576:	6a 00                	push   $0x0
  pushl $39
80106578:	6a 27                	push   $0x27
  jmp alltraps
8010657a:	e9 40 f9 ff ff       	jmp    80105ebf <alltraps>

8010657f <vector40>:
.globl vector40
vector40:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $40
80106581:	6a 28                	push   $0x28
  jmp alltraps
80106583:	e9 37 f9 ff ff       	jmp    80105ebf <alltraps>

80106588 <vector41>:
.globl vector41
vector41:
  pushl $0
80106588:	6a 00                	push   $0x0
  pushl $41
8010658a:	6a 29                	push   $0x29
  jmp alltraps
8010658c:	e9 2e f9 ff ff       	jmp    80105ebf <alltraps>

80106591 <vector42>:
.globl vector42
vector42:
  pushl $0
80106591:	6a 00                	push   $0x0
  pushl $42
80106593:	6a 2a                	push   $0x2a
  jmp alltraps
80106595:	e9 25 f9 ff ff       	jmp    80105ebf <alltraps>

8010659a <vector43>:
.globl vector43
vector43:
  pushl $0
8010659a:	6a 00                	push   $0x0
  pushl $43
8010659c:	6a 2b                	push   $0x2b
  jmp alltraps
8010659e:	e9 1c f9 ff ff       	jmp    80105ebf <alltraps>

801065a3 <vector44>:
.globl vector44
vector44:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $44
801065a5:	6a 2c                	push   $0x2c
  jmp alltraps
801065a7:	e9 13 f9 ff ff       	jmp    80105ebf <alltraps>

801065ac <vector45>:
.globl vector45
vector45:
  pushl $0
801065ac:	6a 00                	push   $0x0
  pushl $45
801065ae:	6a 2d                	push   $0x2d
  jmp alltraps
801065b0:	e9 0a f9 ff ff       	jmp    80105ebf <alltraps>

801065b5 <vector46>:
.globl vector46
vector46:
  pushl $0
801065b5:	6a 00                	push   $0x0
  pushl $46
801065b7:	6a 2e                	push   $0x2e
  jmp alltraps
801065b9:	e9 01 f9 ff ff       	jmp    80105ebf <alltraps>

801065be <vector47>:
.globl vector47
vector47:
  pushl $0
801065be:	6a 00                	push   $0x0
  pushl $47
801065c0:	6a 2f                	push   $0x2f
  jmp alltraps
801065c2:	e9 f8 f8 ff ff       	jmp    80105ebf <alltraps>

801065c7 <vector48>:
.globl vector48
vector48:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $48
801065c9:	6a 30                	push   $0x30
  jmp alltraps
801065cb:	e9 ef f8 ff ff       	jmp    80105ebf <alltraps>

801065d0 <vector49>:
.globl vector49
vector49:
  pushl $0
801065d0:	6a 00                	push   $0x0
  pushl $49
801065d2:	6a 31                	push   $0x31
  jmp alltraps
801065d4:	e9 e6 f8 ff ff       	jmp    80105ebf <alltraps>

801065d9 <vector50>:
.globl vector50
vector50:
  pushl $0
801065d9:	6a 00                	push   $0x0
  pushl $50
801065db:	6a 32                	push   $0x32
  jmp alltraps
801065dd:	e9 dd f8 ff ff       	jmp    80105ebf <alltraps>

801065e2 <vector51>:
.globl vector51
vector51:
  pushl $0
801065e2:	6a 00                	push   $0x0
  pushl $51
801065e4:	6a 33                	push   $0x33
  jmp alltraps
801065e6:	e9 d4 f8 ff ff       	jmp    80105ebf <alltraps>

801065eb <vector52>:
.globl vector52
vector52:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $52
801065ed:	6a 34                	push   $0x34
  jmp alltraps
801065ef:	e9 cb f8 ff ff       	jmp    80105ebf <alltraps>

801065f4 <vector53>:
.globl vector53
vector53:
  pushl $0
801065f4:	6a 00                	push   $0x0
  pushl $53
801065f6:	6a 35                	push   $0x35
  jmp alltraps
801065f8:	e9 c2 f8 ff ff       	jmp    80105ebf <alltraps>

801065fd <vector54>:
.globl vector54
vector54:
  pushl $0
801065fd:	6a 00                	push   $0x0
  pushl $54
801065ff:	6a 36                	push   $0x36
  jmp alltraps
80106601:	e9 b9 f8 ff ff       	jmp    80105ebf <alltraps>

80106606 <vector55>:
.globl vector55
vector55:
  pushl $0
80106606:	6a 00                	push   $0x0
  pushl $55
80106608:	6a 37                	push   $0x37
  jmp alltraps
8010660a:	e9 b0 f8 ff ff       	jmp    80105ebf <alltraps>

8010660f <vector56>:
.globl vector56
vector56:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $56
80106611:	6a 38                	push   $0x38
  jmp alltraps
80106613:	e9 a7 f8 ff ff       	jmp    80105ebf <alltraps>

80106618 <vector57>:
.globl vector57
vector57:
  pushl $0
80106618:	6a 00                	push   $0x0
  pushl $57
8010661a:	6a 39                	push   $0x39
  jmp alltraps
8010661c:	e9 9e f8 ff ff       	jmp    80105ebf <alltraps>

80106621 <vector58>:
.globl vector58
vector58:
  pushl $0
80106621:	6a 00                	push   $0x0
  pushl $58
80106623:	6a 3a                	push   $0x3a
  jmp alltraps
80106625:	e9 95 f8 ff ff       	jmp    80105ebf <alltraps>

8010662a <vector59>:
.globl vector59
vector59:
  pushl $0
8010662a:	6a 00                	push   $0x0
  pushl $59
8010662c:	6a 3b                	push   $0x3b
  jmp alltraps
8010662e:	e9 8c f8 ff ff       	jmp    80105ebf <alltraps>

80106633 <vector60>:
.globl vector60
vector60:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $60
80106635:	6a 3c                	push   $0x3c
  jmp alltraps
80106637:	e9 83 f8 ff ff       	jmp    80105ebf <alltraps>

8010663c <vector61>:
.globl vector61
vector61:
  pushl $0
8010663c:	6a 00                	push   $0x0
  pushl $61
8010663e:	6a 3d                	push   $0x3d
  jmp alltraps
80106640:	e9 7a f8 ff ff       	jmp    80105ebf <alltraps>

80106645 <vector62>:
.globl vector62
vector62:
  pushl $0
80106645:	6a 00                	push   $0x0
  pushl $62
80106647:	6a 3e                	push   $0x3e
  jmp alltraps
80106649:	e9 71 f8 ff ff       	jmp    80105ebf <alltraps>

8010664e <vector63>:
.globl vector63
vector63:
  pushl $0
8010664e:	6a 00                	push   $0x0
  pushl $63
80106650:	6a 3f                	push   $0x3f
  jmp alltraps
80106652:	e9 68 f8 ff ff       	jmp    80105ebf <alltraps>

80106657 <vector64>:
.globl vector64
vector64:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $64
80106659:	6a 40                	push   $0x40
  jmp alltraps
8010665b:	e9 5f f8 ff ff       	jmp    80105ebf <alltraps>

80106660 <vector65>:
.globl vector65
vector65:
  pushl $0
80106660:	6a 00                	push   $0x0
  pushl $65
80106662:	6a 41                	push   $0x41
  jmp alltraps
80106664:	e9 56 f8 ff ff       	jmp    80105ebf <alltraps>

80106669 <vector66>:
.globl vector66
vector66:
  pushl $0
80106669:	6a 00                	push   $0x0
  pushl $66
8010666b:	6a 42                	push   $0x42
  jmp alltraps
8010666d:	e9 4d f8 ff ff       	jmp    80105ebf <alltraps>

80106672 <vector67>:
.globl vector67
vector67:
  pushl $0
80106672:	6a 00                	push   $0x0
  pushl $67
80106674:	6a 43                	push   $0x43
  jmp alltraps
80106676:	e9 44 f8 ff ff       	jmp    80105ebf <alltraps>

8010667b <vector68>:
.globl vector68
vector68:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $68
8010667d:	6a 44                	push   $0x44
  jmp alltraps
8010667f:	e9 3b f8 ff ff       	jmp    80105ebf <alltraps>

80106684 <vector69>:
.globl vector69
vector69:
  pushl $0
80106684:	6a 00                	push   $0x0
  pushl $69
80106686:	6a 45                	push   $0x45
  jmp alltraps
80106688:	e9 32 f8 ff ff       	jmp    80105ebf <alltraps>

8010668d <vector70>:
.globl vector70
vector70:
  pushl $0
8010668d:	6a 00                	push   $0x0
  pushl $70
8010668f:	6a 46                	push   $0x46
  jmp alltraps
80106691:	e9 29 f8 ff ff       	jmp    80105ebf <alltraps>

80106696 <vector71>:
.globl vector71
vector71:
  pushl $0
80106696:	6a 00                	push   $0x0
  pushl $71
80106698:	6a 47                	push   $0x47
  jmp alltraps
8010669a:	e9 20 f8 ff ff       	jmp    80105ebf <alltraps>

8010669f <vector72>:
.globl vector72
vector72:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $72
801066a1:	6a 48                	push   $0x48
  jmp alltraps
801066a3:	e9 17 f8 ff ff       	jmp    80105ebf <alltraps>

801066a8 <vector73>:
.globl vector73
vector73:
  pushl $0
801066a8:	6a 00                	push   $0x0
  pushl $73
801066aa:	6a 49                	push   $0x49
  jmp alltraps
801066ac:	e9 0e f8 ff ff       	jmp    80105ebf <alltraps>

801066b1 <vector74>:
.globl vector74
vector74:
  pushl $0
801066b1:	6a 00                	push   $0x0
  pushl $74
801066b3:	6a 4a                	push   $0x4a
  jmp alltraps
801066b5:	e9 05 f8 ff ff       	jmp    80105ebf <alltraps>

801066ba <vector75>:
.globl vector75
vector75:
  pushl $0
801066ba:	6a 00                	push   $0x0
  pushl $75
801066bc:	6a 4b                	push   $0x4b
  jmp alltraps
801066be:	e9 fc f7 ff ff       	jmp    80105ebf <alltraps>

801066c3 <vector76>:
.globl vector76
vector76:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $76
801066c5:	6a 4c                	push   $0x4c
  jmp alltraps
801066c7:	e9 f3 f7 ff ff       	jmp    80105ebf <alltraps>

801066cc <vector77>:
.globl vector77
vector77:
  pushl $0
801066cc:	6a 00                	push   $0x0
  pushl $77
801066ce:	6a 4d                	push   $0x4d
  jmp alltraps
801066d0:	e9 ea f7 ff ff       	jmp    80105ebf <alltraps>

801066d5 <vector78>:
.globl vector78
vector78:
  pushl $0
801066d5:	6a 00                	push   $0x0
  pushl $78
801066d7:	6a 4e                	push   $0x4e
  jmp alltraps
801066d9:	e9 e1 f7 ff ff       	jmp    80105ebf <alltraps>

801066de <vector79>:
.globl vector79
vector79:
  pushl $0
801066de:	6a 00                	push   $0x0
  pushl $79
801066e0:	6a 4f                	push   $0x4f
  jmp alltraps
801066e2:	e9 d8 f7 ff ff       	jmp    80105ebf <alltraps>

801066e7 <vector80>:
.globl vector80
vector80:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $80
801066e9:	6a 50                	push   $0x50
  jmp alltraps
801066eb:	e9 cf f7 ff ff       	jmp    80105ebf <alltraps>

801066f0 <vector81>:
.globl vector81
vector81:
  pushl $0
801066f0:	6a 00                	push   $0x0
  pushl $81
801066f2:	6a 51                	push   $0x51
  jmp alltraps
801066f4:	e9 c6 f7 ff ff       	jmp    80105ebf <alltraps>

801066f9 <vector82>:
.globl vector82
vector82:
  pushl $0
801066f9:	6a 00                	push   $0x0
  pushl $82
801066fb:	6a 52                	push   $0x52
  jmp alltraps
801066fd:	e9 bd f7 ff ff       	jmp    80105ebf <alltraps>

80106702 <vector83>:
.globl vector83
vector83:
  pushl $0
80106702:	6a 00                	push   $0x0
  pushl $83
80106704:	6a 53                	push   $0x53
  jmp alltraps
80106706:	e9 b4 f7 ff ff       	jmp    80105ebf <alltraps>

8010670b <vector84>:
.globl vector84
vector84:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $84
8010670d:	6a 54                	push   $0x54
  jmp alltraps
8010670f:	e9 ab f7 ff ff       	jmp    80105ebf <alltraps>

80106714 <vector85>:
.globl vector85
vector85:
  pushl $0
80106714:	6a 00                	push   $0x0
  pushl $85
80106716:	6a 55                	push   $0x55
  jmp alltraps
80106718:	e9 a2 f7 ff ff       	jmp    80105ebf <alltraps>

8010671d <vector86>:
.globl vector86
vector86:
  pushl $0
8010671d:	6a 00                	push   $0x0
  pushl $86
8010671f:	6a 56                	push   $0x56
  jmp alltraps
80106721:	e9 99 f7 ff ff       	jmp    80105ebf <alltraps>

80106726 <vector87>:
.globl vector87
vector87:
  pushl $0
80106726:	6a 00                	push   $0x0
  pushl $87
80106728:	6a 57                	push   $0x57
  jmp alltraps
8010672a:	e9 90 f7 ff ff       	jmp    80105ebf <alltraps>

8010672f <vector88>:
.globl vector88
vector88:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $88
80106731:	6a 58                	push   $0x58
  jmp alltraps
80106733:	e9 87 f7 ff ff       	jmp    80105ebf <alltraps>

80106738 <vector89>:
.globl vector89
vector89:
  pushl $0
80106738:	6a 00                	push   $0x0
  pushl $89
8010673a:	6a 59                	push   $0x59
  jmp alltraps
8010673c:	e9 7e f7 ff ff       	jmp    80105ebf <alltraps>

80106741 <vector90>:
.globl vector90
vector90:
  pushl $0
80106741:	6a 00                	push   $0x0
  pushl $90
80106743:	6a 5a                	push   $0x5a
  jmp alltraps
80106745:	e9 75 f7 ff ff       	jmp    80105ebf <alltraps>

8010674a <vector91>:
.globl vector91
vector91:
  pushl $0
8010674a:	6a 00                	push   $0x0
  pushl $91
8010674c:	6a 5b                	push   $0x5b
  jmp alltraps
8010674e:	e9 6c f7 ff ff       	jmp    80105ebf <alltraps>

80106753 <vector92>:
.globl vector92
vector92:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $92
80106755:	6a 5c                	push   $0x5c
  jmp alltraps
80106757:	e9 63 f7 ff ff       	jmp    80105ebf <alltraps>

8010675c <vector93>:
.globl vector93
vector93:
  pushl $0
8010675c:	6a 00                	push   $0x0
  pushl $93
8010675e:	6a 5d                	push   $0x5d
  jmp alltraps
80106760:	e9 5a f7 ff ff       	jmp    80105ebf <alltraps>

80106765 <vector94>:
.globl vector94
vector94:
  pushl $0
80106765:	6a 00                	push   $0x0
  pushl $94
80106767:	6a 5e                	push   $0x5e
  jmp alltraps
80106769:	e9 51 f7 ff ff       	jmp    80105ebf <alltraps>

8010676e <vector95>:
.globl vector95
vector95:
  pushl $0
8010676e:	6a 00                	push   $0x0
  pushl $95
80106770:	6a 5f                	push   $0x5f
  jmp alltraps
80106772:	e9 48 f7 ff ff       	jmp    80105ebf <alltraps>

80106777 <vector96>:
.globl vector96
vector96:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $96
80106779:	6a 60                	push   $0x60
  jmp alltraps
8010677b:	e9 3f f7 ff ff       	jmp    80105ebf <alltraps>

80106780 <vector97>:
.globl vector97
vector97:
  pushl $0
80106780:	6a 00                	push   $0x0
  pushl $97
80106782:	6a 61                	push   $0x61
  jmp alltraps
80106784:	e9 36 f7 ff ff       	jmp    80105ebf <alltraps>

80106789 <vector98>:
.globl vector98
vector98:
  pushl $0
80106789:	6a 00                	push   $0x0
  pushl $98
8010678b:	6a 62                	push   $0x62
  jmp alltraps
8010678d:	e9 2d f7 ff ff       	jmp    80105ebf <alltraps>

80106792 <vector99>:
.globl vector99
vector99:
  pushl $0
80106792:	6a 00                	push   $0x0
  pushl $99
80106794:	6a 63                	push   $0x63
  jmp alltraps
80106796:	e9 24 f7 ff ff       	jmp    80105ebf <alltraps>

8010679b <vector100>:
.globl vector100
vector100:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $100
8010679d:	6a 64                	push   $0x64
  jmp alltraps
8010679f:	e9 1b f7 ff ff       	jmp    80105ebf <alltraps>

801067a4 <vector101>:
.globl vector101
vector101:
  pushl $0
801067a4:	6a 00                	push   $0x0
  pushl $101
801067a6:	6a 65                	push   $0x65
  jmp alltraps
801067a8:	e9 12 f7 ff ff       	jmp    80105ebf <alltraps>

801067ad <vector102>:
.globl vector102
vector102:
  pushl $0
801067ad:	6a 00                	push   $0x0
  pushl $102
801067af:	6a 66                	push   $0x66
  jmp alltraps
801067b1:	e9 09 f7 ff ff       	jmp    80105ebf <alltraps>

801067b6 <vector103>:
.globl vector103
vector103:
  pushl $0
801067b6:	6a 00                	push   $0x0
  pushl $103
801067b8:	6a 67                	push   $0x67
  jmp alltraps
801067ba:	e9 00 f7 ff ff       	jmp    80105ebf <alltraps>

801067bf <vector104>:
.globl vector104
vector104:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $104
801067c1:	6a 68                	push   $0x68
  jmp alltraps
801067c3:	e9 f7 f6 ff ff       	jmp    80105ebf <alltraps>

801067c8 <vector105>:
.globl vector105
vector105:
  pushl $0
801067c8:	6a 00                	push   $0x0
  pushl $105
801067ca:	6a 69                	push   $0x69
  jmp alltraps
801067cc:	e9 ee f6 ff ff       	jmp    80105ebf <alltraps>

801067d1 <vector106>:
.globl vector106
vector106:
  pushl $0
801067d1:	6a 00                	push   $0x0
  pushl $106
801067d3:	6a 6a                	push   $0x6a
  jmp alltraps
801067d5:	e9 e5 f6 ff ff       	jmp    80105ebf <alltraps>

801067da <vector107>:
.globl vector107
vector107:
  pushl $0
801067da:	6a 00                	push   $0x0
  pushl $107
801067dc:	6a 6b                	push   $0x6b
  jmp alltraps
801067de:	e9 dc f6 ff ff       	jmp    80105ebf <alltraps>

801067e3 <vector108>:
.globl vector108
vector108:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $108
801067e5:	6a 6c                	push   $0x6c
  jmp alltraps
801067e7:	e9 d3 f6 ff ff       	jmp    80105ebf <alltraps>

801067ec <vector109>:
.globl vector109
vector109:
  pushl $0
801067ec:	6a 00                	push   $0x0
  pushl $109
801067ee:	6a 6d                	push   $0x6d
  jmp alltraps
801067f0:	e9 ca f6 ff ff       	jmp    80105ebf <alltraps>

801067f5 <vector110>:
.globl vector110
vector110:
  pushl $0
801067f5:	6a 00                	push   $0x0
  pushl $110
801067f7:	6a 6e                	push   $0x6e
  jmp alltraps
801067f9:	e9 c1 f6 ff ff       	jmp    80105ebf <alltraps>

801067fe <vector111>:
.globl vector111
vector111:
  pushl $0
801067fe:	6a 00                	push   $0x0
  pushl $111
80106800:	6a 6f                	push   $0x6f
  jmp alltraps
80106802:	e9 b8 f6 ff ff       	jmp    80105ebf <alltraps>

80106807 <vector112>:
.globl vector112
vector112:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $112
80106809:	6a 70                	push   $0x70
  jmp alltraps
8010680b:	e9 af f6 ff ff       	jmp    80105ebf <alltraps>

80106810 <vector113>:
.globl vector113
vector113:
  pushl $0
80106810:	6a 00                	push   $0x0
  pushl $113
80106812:	6a 71                	push   $0x71
  jmp alltraps
80106814:	e9 a6 f6 ff ff       	jmp    80105ebf <alltraps>

80106819 <vector114>:
.globl vector114
vector114:
  pushl $0
80106819:	6a 00                	push   $0x0
  pushl $114
8010681b:	6a 72                	push   $0x72
  jmp alltraps
8010681d:	e9 9d f6 ff ff       	jmp    80105ebf <alltraps>

80106822 <vector115>:
.globl vector115
vector115:
  pushl $0
80106822:	6a 00                	push   $0x0
  pushl $115
80106824:	6a 73                	push   $0x73
  jmp alltraps
80106826:	e9 94 f6 ff ff       	jmp    80105ebf <alltraps>

8010682b <vector116>:
.globl vector116
vector116:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $116
8010682d:	6a 74                	push   $0x74
  jmp alltraps
8010682f:	e9 8b f6 ff ff       	jmp    80105ebf <alltraps>

80106834 <vector117>:
.globl vector117
vector117:
  pushl $0
80106834:	6a 00                	push   $0x0
  pushl $117
80106836:	6a 75                	push   $0x75
  jmp alltraps
80106838:	e9 82 f6 ff ff       	jmp    80105ebf <alltraps>

8010683d <vector118>:
.globl vector118
vector118:
  pushl $0
8010683d:	6a 00                	push   $0x0
  pushl $118
8010683f:	6a 76                	push   $0x76
  jmp alltraps
80106841:	e9 79 f6 ff ff       	jmp    80105ebf <alltraps>

80106846 <vector119>:
.globl vector119
vector119:
  pushl $0
80106846:	6a 00                	push   $0x0
  pushl $119
80106848:	6a 77                	push   $0x77
  jmp alltraps
8010684a:	e9 70 f6 ff ff       	jmp    80105ebf <alltraps>

8010684f <vector120>:
.globl vector120
vector120:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $120
80106851:	6a 78                	push   $0x78
  jmp alltraps
80106853:	e9 67 f6 ff ff       	jmp    80105ebf <alltraps>

80106858 <vector121>:
.globl vector121
vector121:
  pushl $0
80106858:	6a 00                	push   $0x0
  pushl $121
8010685a:	6a 79                	push   $0x79
  jmp alltraps
8010685c:	e9 5e f6 ff ff       	jmp    80105ebf <alltraps>

80106861 <vector122>:
.globl vector122
vector122:
  pushl $0
80106861:	6a 00                	push   $0x0
  pushl $122
80106863:	6a 7a                	push   $0x7a
  jmp alltraps
80106865:	e9 55 f6 ff ff       	jmp    80105ebf <alltraps>

8010686a <vector123>:
.globl vector123
vector123:
  pushl $0
8010686a:	6a 00                	push   $0x0
  pushl $123
8010686c:	6a 7b                	push   $0x7b
  jmp alltraps
8010686e:	e9 4c f6 ff ff       	jmp    80105ebf <alltraps>

80106873 <vector124>:
.globl vector124
vector124:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $124
80106875:	6a 7c                	push   $0x7c
  jmp alltraps
80106877:	e9 43 f6 ff ff       	jmp    80105ebf <alltraps>

8010687c <vector125>:
.globl vector125
vector125:
  pushl $0
8010687c:	6a 00                	push   $0x0
  pushl $125
8010687e:	6a 7d                	push   $0x7d
  jmp alltraps
80106880:	e9 3a f6 ff ff       	jmp    80105ebf <alltraps>

80106885 <vector126>:
.globl vector126
vector126:
  pushl $0
80106885:	6a 00                	push   $0x0
  pushl $126
80106887:	6a 7e                	push   $0x7e
  jmp alltraps
80106889:	e9 31 f6 ff ff       	jmp    80105ebf <alltraps>

8010688e <vector127>:
.globl vector127
vector127:
  pushl $0
8010688e:	6a 00                	push   $0x0
  pushl $127
80106890:	6a 7f                	push   $0x7f
  jmp alltraps
80106892:	e9 28 f6 ff ff       	jmp    80105ebf <alltraps>

80106897 <vector128>:
.globl vector128
vector128:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $128
80106899:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010689e:	e9 1c f6 ff ff       	jmp    80105ebf <alltraps>

801068a3 <vector129>:
.globl vector129
vector129:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $129
801068a5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801068aa:	e9 10 f6 ff ff       	jmp    80105ebf <alltraps>

801068af <vector130>:
.globl vector130
vector130:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $130
801068b1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801068b6:	e9 04 f6 ff ff       	jmp    80105ebf <alltraps>

801068bb <vector131>:
.globl vector131
vector131:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $131
801068bd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801068c2:	e9 f8 f5 ff ff       	jmp    80105ebf <alltraps>

801068c7 <vector132>:
.globl vector132
vector132:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $132
801068c9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801068ce:	e9 ec f5 ff ff       	jmp    80105ebf <alltraps>

801068d3 <vector133>:
.globl vector133
vector133:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $133
801068d5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801068da:	e9 e0 f5 ff ff       	jmp    80105ebf <alltraps>

801068df <vector134>:
.globl vector134
vector134:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $134
801068e1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801068e6:	e9 d4 f5 ff ff       	jmp    80105ebf <alltraps>

801068eb <vector135>:
.globl vector135
vector135:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $135
801068ed:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801068f2:	e9 c8 f5 ff ff       	jmp    80105ebf <alltraps>

801068f7 <vector136>:
.globl vector136
vector136:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $136
801068f9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801068fe:	e9 bc f5 ff ff       	jmp    80105ebf <alltraps>

80106903 <vector137>:
.globl vector137
vector137:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $137
80106905:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010690a:	e9 b0 f5 ff ff       	jmp    80105ebf <alltraps>

8010690f <vector138>:
.globl vector138
vector138:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $138
80106911:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106916:	e9 a4 f5 ff ff       	jmp    80105ebf <alltraps>

8010691b <vector139>:
.globl vector139
vector139:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $139
8010691d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106922:	e9 98 f5 ff ff       	jmp    80105ebf <alltraps>

80106927 <vector140>:
.globl vector140
vector140:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $140
80106929:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010692e:	e9 8c f5 ff ff       	jmp    80105ebf <alltraps>

80106933 <vector141>:
.globl vector141
vector141:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $141
80106935:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010693a:	e9 80 f5 ff ff       	jmp    80105ebf <alltraps>

8010693f <vector142>:
.globl vector142
vector142:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $142
80106941:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106946:	e9 74 f5 ff ff       	jmp    80105ebf <alltraps>

8010694b <vector143>:
.globl vector143
vector143:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $143
8010694d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106952:	e9 68 f5 ff ff       	jmp    80105ebf <alltraps>

80106957 <vector144>:
.globl vector144
vector144:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $144
80106959:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010695e:	e9 5c f5 ff ff       	jmp    80105ebf <alltraps>

80106963 <vector145>:
.globl vector145
vector145:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $145
80106965:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010696a:	e9 50 f5 ff ff       	jmp    80105ebf <alltraps>

8010696f <vector146>:
.globl vector146
vector146:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $146
80106971:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106976:	e9 44 f5 ff ff       	jmp    80105ebf <alltraps>

8010697b <vector147>:
.globl vector147
vector147:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $147
8010697d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106982:	e9 38 f5 ff ff       	jmp    80105ebf <alltraps>

80106987 <vector148>:
.globl vector148
vector148:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $148
80106989:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010698e:	e9 2c f5 ff ff       	jmp    80105ebf <alltraps>

80106993 <vector149>:
.globl vector149
vector149:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $149
80106995:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010699a:	e9 20 f5 ff ff       	jmp    80105ebf <alltraps>

8010699f <vector150>:
.globl vector150
vector150:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $150
801069a1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801069a6:	e9 14 f5 ff ff       	jmp    80105ebf <alltraps>

801069ab <vector151>:
.globl vector151
vector151:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $151
801069ad:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801069b2:	e9 08 f5 ff ff       	jmp    80105ebf <alltraps>

801069b7 <vector152>:
.globl vector152
vector152:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $152
801069b9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801069be:	e9 fc f4 ff ff       	jmp    80105ebf <alltraps>

801069c3 <vector153>:
.globl vector153
vector153:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $153
801069c5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801069ca:	e9 f0 f4 ff ff       	jmp    80105ebf <alltraps>

801069cf <vector154>:
.globl vector154
vector154:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $154
801069d1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801069d6:	e9 e4 f4 ff ff       	jmp    80105ebf <alltraps>

801069db <vector155>:
.globl vector155
vector155:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $155
801069dd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801069e2:	e9 d8 f4 ff ff       	jmp    80105ebf <alltraps>

801069e7 <vector156>:
.globl vector156
vector156:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $156
801069e9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801069ee:	e9 cc f4 ff ff       	jmp    80105ebf <alltraps>

801069f3 <vector157>:
.globl vector157
vector157:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $157
801069f5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801069fa:	e9 c0 f4 ff ff       	jmp    80105ebf <alltraps>

801069ff <vector158>:
.globl vector158
vector158:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $158
80106a01:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106a06:	e9 b4 f4 ff ff       	jmp    80105ebf <alltraps>

80106a0b <vector159>:
.globl vector159
vector159:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $159
80106a0d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106a12:	e9 a8 f4 ff ff       	jmp    80105ebf <alltraps>

80106a17 <vector160>:
.globl vector160
vector160:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $160
80106a19:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106a1e:	e9 9c f4 ff ff       	jmp    80105ebf <alltraps>

80106a23 <vector161>:
.globl vector161
vector161:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $161
80106a25:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106a2a:	e9 90 f4 ff ff       	jmp    80105ebf <alltraps>

80106a2f <vector162>:
.globl vector162
vector162:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $162
80106a31:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106a36:	e9 84 f4 ff ff       	jmp    80105ebf <alltraps>

80106a3b <vector163>:
.globl vector163
vector163:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $163
80106a3d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106a42:	e9 78 f4 ff ff       	jmp    80105ebf <alltraps>

80106a47 <vector164>:
.globl vector164
vector164:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $164
80106a49:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106a4e:	e9 6c f4 ff ff       	jmp    80105ebf <alltraps>

80106a53 <vector165>:
.globl vector165
vector165:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $165
80106a55:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106a5a:	e9 60 f4 ff ff       	jmp    80105ebf <alltraps>

80106a5f <vector166>:
.globl vector166
vector166:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $166
80106a61:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106a66:	e9 54 f4 ff ff       	jmp    80105ebf <alltraps>

80106a6b <vector167>:
.globl vector167
vector167:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $167
80106a6d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106a72:	e9 48 f4 ff ff       	jmp    80105ebf <alltraps>

80106a77 <vector168>:
.globl vector168
vector168:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $168
80106a79:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106a7e:	e9 3c f4 ff ff       	jmp    80105ebf <alltraps>

80106a83 <vector169>:
.globl vector169
vector169:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $169
80106a85:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106a8a:	e9 30 f4 ff ff       	jmp    80105ebf <alltraps>

80106a8f <vector170>:
.globl vector170
vector170:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $170
80106a91:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106a96:	e9 24 f4 ff ff       	jmp    80105ebf <alltraps>

80106a9b <vector171>:
.globl vector171
vector171:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $171
80106a9d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106aa2:	e9 18 f4 ff ff       	jmp    80105ebf <alltraps>

80106aa7 <vector172>:
.globl vector172
vector172:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $172
80106aa9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106aae:	e9 0c f4 ff ff       	jmp    80105ebf <alltraps>

80106ab3 <vector173>:
.globl vector173
vector173:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $173
80106ab5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106aba:	e9 00 f4 ff ff       	jmp    80105ebf <alltraps>

80106abf <vector174>:
.globl vector174
vector174:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $174
80106ac1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106ac6:	e9 f4 f3 ff ff       	jmp    80105ebf <alltraps>

80106acb <vector175>:
.globl vector175
vector175:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $175
80106acd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106ad2:	e9 e8 f3 ff ff       	jmp    80105ebf <alltraps>

80106ad7 <vector176>:
.globl vector176
vector176:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $176
80106ad9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106ade:	e9 dc f3 ff ff       	jmp    80105ebf <alltraps>

80106ae3 <vector177>:
.globl vector177
vector177:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $177
80106ae5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106aea:	e9 d0 f3 ff ff       	jmp    80105ebf <alltraps>

80106aef <vector178>:
.globl vector178
vector178:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $178
80106af1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106af6:	e9 c4 f3 ff ff       	jmp    80105ebf <alltraps>

80106afb <vector179>:
.globl vector179
vector179:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $179
80106afd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106b02:	e9 b8 f3 ff ff       	jmp    80105ebf <alltraps>

80106b07 <vector180>:
.globl vector180
vector180:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $180
80106b09:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106b0e:	e9 ac f3 ff ff       	jmp    80105ebf <alltraps>

80106b13 <vector181>:
.globl vector181
vector181:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $181
80106b15:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106b1a:	e9 a0 f3 ff ff       	jmp    80105ebf <alltraps>

80106b1f <vector182>:
.globl vector182
vector182:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $182
80106b21:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106b26:	e9 94 f3 ff ff       	jmp    80105ebf <alltraps>

80106b2b <vector183>:
.globl vector183
vector183:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $183
80106b2d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106b32:	e9 88 f3 ff ff       	jmp    80105ebf <alltraps>

80106b37 <vector184>:
.globl vector184
vector184:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $184
80106b39:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106b3e:	e9 7c f3 ff ff       	jmp    80105ebf <alltraps>

80106b43 <vector185>:
.globl vector185
vector185:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $185
80106b45:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106b4a:	e9 70 f3 ff ff       	jmp    80105ebf <alltraps>

80106b4f <vector186>:
.globl vector186
vector186:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $186
80106b51:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106b56:	e9 64 f3 ff ff       	jmp    80105ebf <alltraps>

80106b5b <vector187>:
.globl vector187
vector187:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $187
80106b5d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106b62:	e9 58 f3 ff ff       	jmp    80105ebf <alltraps>

80106b67 <vector188>:
.globl vector188
vector188:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $188
80106b69:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106b6e:	e9 4c f3 ff ff       	jmp    80105ebf <alltraps>

80106b73 <vector189>:
.globl vector189
vector189:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $189
80106b75:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106b7a:	e9 40 f3 ff ff       	jmp    80105ebf <alltraps>

80106b7f <vector190>:
.globl vector190
vector190:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $190
80106b81:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106b86:	e9 34 f3 ff ff       	jmp    80105ebf <alltraps>

80106b8b <vector191>:
.globl vector191
vector191:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $191
80106b8d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106b92:	e9 28 f3 ff ff       	jmp    80105ebf <alltraps>

80106b97 <vector192>:
.globl vector192
vector192:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $192
80106b99:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106b9e:	e9 1c f3 ff ff       	jmp    80105ebf <alltraps>

80106ba3 <vector193>:
.globl vector193
vector193:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $193
80106ba5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106baa:	e9 10 f3 ff ff       	jmp    80105ebf <alltraps>

80106baf <vector194>:
.globl vector194
vector194:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $194
80106bb1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106bb6:	e9 04 f3 ff ff       	jmp    80105ebf <alltraps>

80106bbb <vector195>:
.globl vector195
vector195:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $195
80106bbd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106bc2:	e9 f8 f2 ff ff       	jmp    80105ebf <alltraps>

80106bc7 <vector196>:
.globl vector196
vector196:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $196
80106bc9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106bce:	e9 ec f2 ff ff       	jmp    80105ebf <alltraps>

80106bd3 <vector197>:
.globl vector197
vector197:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $197
80106bd5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106bda:	e9 e0 f2 ff ff       	jmp    80105ebf <alltraps>

80106bdf <vector198>:
.globl vector198
vector198:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $198
80106be1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106be6:	e9 d4 f2 ff ff       	jmp    80105ebf <alltraps>

80106beb <vector199>:
.globl vector199
vector199:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $199
80106bed:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106bf2:	e9 c8 f2 ff ff       	jmp    80105ebf <alltraps>

80106bf7 <vector200>:
.globl vector200
vector200:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $200
80106bf9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106bfe:	e9 bc f2 ff ff       	jmp    80105ebf <alltraps>

80106c03 <vector201>:
.globl vector201
vector201:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $201
80106c05:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106c0a:	e9 b0 f2 ff ff       	jmp    80105ebf <alltraps>

80106c0f <vector202>:
.globl vector202
vector202:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $202
80106c11:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106c16:	e9 a4 f2 ff ff       	jmp    80105ebf <alltraps>

80106c1b <vector203>:
.globl vector203
vector203:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $203
80106c1d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106c22:	e9 98 f2 ff ff       	jmp    80105ebf <alltraps>

80106c27 <vector204>:
.globl vector204
vector204:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $204
80106c29:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106c2e:	e9 8c f2 ff ff       	jmp    80105ebf <alltraps>

80106c33 <vector205>:
.globl vector205
vector205:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $205
80106c35:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106c3a:	e9 80 f2 ff ff       	jmp    80105ebf <alltraps>

80106c3f <vector206>:
.globl vector206
vector206:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $206
80106c41:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106c46:	e9 74 f2 ff ff       	jmp    80105ebf <alltraps>

80106c4b <vector207>:
.globl vector207
vector207:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $207
80106c4d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106c52:	e9 68 f2 ff ff       	jmp    80105ebf <alltraps>

80106c57 <vector208>:
.globl vector208
vector208:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $208
80106c59:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106c5e:	e9 5c f2 ff ff       	jmp    80105ebf <alltraps>

80106c63 <vector209>:
.globl vector209
vector209:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $209
80106c65:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106c6a:	e9 50 f2 ff ff       	jmp    80105ebf <alltraps>

80106c6f <vector210>:
.globl vector210
vector210:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $210
80106c71:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106c76:	e9 44 f2 ff ff       	jmp    80105ebf <alltraps>

80106c7b <vector211>:
.globl vector211
vector211:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $211
80106c7d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106c82:	e9 38 f2 ff ff       	jmp    80105ebf <alltraps>

80106c87 <vector212>:
.globl vector212
vector212:
  pushl $0
80106c87:	6a 00                	push   $0x0
  pushl $212
80106c89:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106c8e:	e9 2c f2 ff ff       	jmp    80105ebf <alltraps>

80106c93 <vector213>:
.globl vector213
vector213:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $213
80106c95:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106c9a:	e9 20 f2 ff ff       	jmp    80105ebf <alltraps>

80106c9f <vector214>:
.globl vector214
vector214:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $214
80106ca1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106ca6:	e9 14 f2 ff ff       	jmp    80105ebf <alltraps>

80106cab <vector215>:
.globl vector215
vector215:
  pushl $0
80106cab:	6a 00                	push   $0x0
  pushl $215
80106cad:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106cb2:	e9 08 f2 ff ff       	jmp    80105ebf <alltraps>

80106cb7 <vector216>:
.globl vector216
vector216:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $216
80106cb9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106cbe:	e9 fc f1 ff ff       	jmp    80105ebf <alltraps>

80106cc3 <vector217>:
.globl vector217
vector217:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $217
80106cc5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106cca:	e9 f0 f1 ff ff       	jmp    80105ebf <alltraps>

80106ccf <vector218>:
.globl vector218
vector218:
  pushl $0
80106ccf:	6a 00                	push   $0x0
  pushl $218
80106cd1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106cd6:	e9 e4 f1 ff ff       	jmp    80105ebf <alltraps>

80106cdb <vector219>:
.globl vector219
vector219:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $219
80106cdd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106ce2:	e9 d8 f1 ff ff       	jmp    80105ebf <alltraps>

80106ce7 <vector220>:
.globl vector220
vector220:
  pushl $0
80106ce7:	6a 00                	push   $0x0
  pushl $220
80106ce9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106cee:	e9 cc f1 ff ff       	jmp    80105ebf <alltraps>

80106cf3 <vector221>:
.globl vector221
vector221:
  pushl $0
80106cf3:	6a 00                	push   $0x0
  pushl $221
80106cf5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106cfa:	e9 c0 f1 ff ff       	jmp    80105ebf <alltraps>

80106cff <vector222>:
.globl vector222
vector222:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $222
80106d01:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106d06:	e9 b4 f1 ff ff       	jmp    80105ebf <alltraps>

80106d0b <vector223>:
.globl vector223
vector223:
  pushl $0
80106d0b:	6a 00                	push   $0x0
  pushl $223
80106d0d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106d12:	e9 a8 f1 ff ff       	jmp    80105ebf <alltraps>

80106d17 <vector224>:
.globl vector224
vector224:
  pushl $0
80106d17:	6a 00                	push   $0x0
  pushl $224
80106d19:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106d1e:	e9 9c f1 ff ff       	jmp    80105ebf <alltraps>

80106d23 <vector225>:
.globl vector225
vector225:
  pushl $0
80106d23:	6a 00                	push   $0x0
  pushl $225
80106d25:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106d2a:	e9 90 f1 ff ff       	jmp    80105ebf <alltraps>

80106d2f <vector226>:
.globl vector226
vector226:
  pushl $0
80106d2f:	6a 00                	push   $0x0
  pushl $226
80106d31:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106d36:	e9 84 f1 ff ff       	jmp    80105ebf <alltraps>

80106d3b <vector227>:
.globl vector227
vector227:
  pushl $0
80106d3b:	6a 00                	push   $0x0
  pushl $227
80106d3d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106d42:	e9 78 f1 ff ff       	jmp    80105ebf <alltraps>

80106d47 <vector228>:
.globl vector228
vector228:
  pushl $0
80106d47:	6a 00                	push   $0x0
  pushl $228
80106d49:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106d4e:	e9 6c f1 ff ff       	jmp    80105ebf <alltraps>

80106d53 <vector229>:
.globl vector229
vector229:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $229
80106d55:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106d5a:	e9 60 f1 ff ff       	jmp    80105ebf <alltraps>

80106d5f <vector230>:
.globl vector230
vector230:
  pushl $0
80106d5f:	6a 00                	push   $0x0
  pushl $230
80106d61:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106d66:	e9 54 f1 ff ff       	jmp    80105ebf <alltraps>

80106d6b <vector231>:
.globl vector231
vector231:
  pushl $0
80106d6b:	6a 00                	push   $0x0
  pushl $231
80106d6d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106d72:	e9 48 f1 ff ff       	jmp    80105ebf <alltraps>

80106d77 <vector232>:
.globl vector232
vector232:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $232
80106d79:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106d7e:	e9 3c f1 ff ff       	jmp    80105ebf <alltraps>

80106d83 <vector233>:
.globl vector233
vector233:
  pushl $0
80106d83:	6a 00                	push   $0x0
  pushl $233
80106d85:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106d8a:	e9 30 f1 ff ff       	jmp    80105ebf <alltraps>

80106d8f <vector234>:
.globl vector234
vector234:
  pushl $0
80106d8f:	6a 00                	push   $0x0
  pushl $234
80106d91:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106d96:	e9 24 f1 ff ff       	jmp    80105ebf <alltraps>

80106d9b <vector235>:
.globl vector235
vector235:
  pushl $0
80106d9b:	6a 00                	push   $0x0
  pushl $235
80106d9d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106da2:	e9 18 f1 ff ff       	jmp    80105ebf <alltraps>

80106da7 <vector236>:
.globl vector236
vector236:
  pushl $0
80106da7:	6a 00                	push   $0x0
  pushl $236
80106da9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106dae:	e9 0c f1 ff ff       	jmp    80105ebf <alltraps>

80106db3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106db3:	6a 00                	push   $0x0
  pushl $237
80106db5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106dba:	e9 00 f1 ff ff       	jmp    80105ebf <alltraps>

80106dbf <vector238>:
.globl vector238
vector238:
  pushl $0
80106dbf:	6a 00                	push   $0x0
  pushl $238
80106dc1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106dc6:	e9 f4 f0 ff ff       	jmp    80105ebf <alltraps>

80106dcb <vector239>:
.globl vector239
vector239:
  pushl $0
80106dcb:	6a 00                	push   $0x0
  pushl $239
80106dcd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106dd2:	e9 e8 f0 ff ff       	jmp    80105ebf <alltraps>

80106dd7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106dd7:	6a 00                	push   $0x0
  pushl $240
80106dd9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106dde:	e9 dc f0 ff ff       	jmp    80105ebf <alltraps>

80106de3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106de3:	6a 00                	push   $0x0
  pushl $241
80106de5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106dea:	e9 d0 f0 ff ff       	jmp    80105ebf <alltraps>

80106def <vector242>:
.globl vector242
vector242:
  pushl $0
80106def:	6a 00                	push   $0x0
  pushl $242
80106df1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106df6:	e9 c4 f0 ff ff       	jmp    80105ebf <alltraps>

80106dfb <vector243>:
.globl vector243
vector243:
  pushl $0
80106dfb:	6a 00                	push   $0x0
  pushl $243
80106dfd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106e02:	e9 b8 f0 ff ff       	jmp    80105ebf <alltraps>

80106e07 <vector244>:
.globl vector244
vector244:
  pushl $0
80106e07:	6a 00                	push   $0x0
  pushl $244
80106e09:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106e0e:	e9 ac f0 ff ff       	jmp    80105ebf <alltraps>

80106e13 <vector245>:
.globl vector245
vector245:
  pushl $0
80106e13:	6a 00                	push   $0x0
  pushl $245
80106e15:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106e1a:	e9 a0 f0 ff ff       	jmp    80105ebf <alltraps>

80106e1f <vector246>:
.globl vector246
vector246:
  pushl $0
80106e1f:	6a 00                	push   $0x0
  pushl $246
80106e21:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106e26:	e9 94 f0 ff ff       	jmp    80105ebf <alltraps>

80106e2b <vector247>:
.globl vector247
vector247:
  pushl $0
80106e2b:	6a 00                	push   $0x0
  pushl $247
80106e2d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106e32:	e9 88 f0 ff ff       	jmp    80105ebf <alltraps>

80106e37 <vector248>:
.globl vector248
vector248:
  pushl $0
80106e37:	6a 00                	push   $0x0
  pushl $248
80106e39:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106e3e:	e9 7c f0 ff ff       	jmp    80105ebf <alltraps>

80106e43 <vector249>:
.globl vector249
vector249:
  pushl $0
80106e43:	6a 00                	push   $0x0
  pushl $249
80106e45:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106e4a:	e9 70 f0 ff ff       	jmp    80105ebf <alltraps>

80106e4f <vector250>:
.globl vector250
vector250:
  pushl $0
80106e4f:	6a 00                	push   $0x0
  pushl $250
80106e51:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106e56:	e9 64 f0 ff ff       	jmp    80105ebf <alltraps>

80106e5b <vector251>:
.globl vector251
vector251:
  pushl $0
80106e5b:	6a 00                	push   $0x0
  pushl $251
80106e5d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106e62:	e9 58 f0 ff ff       	jmp    80105ebf <alltraps>

80106e67 <vector252>:
.globl vector252
vector252:
  pushl $0
80106e67:	6a 00                	push   $0x0
  pushl $252
80106e69:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106e6e:	e9 4c f0 ff ff       	jmp    80105ebf <alltraps>

80106e73 <vector253>:
.globl vector253
vector253:
  pushl $0
80106e73:	6a 00                	push   $0x0
  pushl $253
80106e75:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106e7a:	e9 40 f0 ff ff       	jmp    80105ebf <alltraps>

80106e7f <vector254>:
.globl vector254
vector254:
  pushl $0
80106e7f:	6a 00                	push   $0x0
  pushl $254
80106e81:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106e86:	e9 34 f0 ff ff       	jmp    80105ebf <alltraps>

80106e8b <vector255>:
.globl vector255
vector255:
  pushl $0
80106e8b:	6a 00                	push   $0x0
  pushl $255
80106e8d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106e92:	e9 28 f0 ff ff       	jmp    80105ebf <alltraps>
80106e97:	66 90                	xchg   %ax,%ax
80106e99:	66 90                	xchg   %ax,%ax
80106e9b:	66 90                	xchg   %ax,%ax
80106e9d:	66 90                	xchg   %ax,%ax
80106e9f:	90                   	nop

80106ea0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106ea0:	55                   	push   %ebp
80106ea1:	89 e5                	mov    %esp,%ebp
80106ea3:	57                   	push   %edi
80106ea4:	56                   	push   %esi
80106ea5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106ea6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106eac:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106eb2:	83 ec 1c             	sub    $0x1c,%esp
80106eb5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106eb8:	39 d3                	cmp    %edx,%ebx
80106eba:	73 49                	jae    80106f05 <deallocuvm.part.0+0x65>
80106ebc:	89 c7                	mov    %eax,%edi
80106ebe:	eb 0c                	jmp    80106ecc <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106ec0:	83 c0 01             	add    $0x1,%eax
80106ec3:	c1 e0 16             	shl    $0x16,%eax
80106ec6:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106ec8:	39 da                	cmp    %ebx,%edx
80106eca:	76 39                	jbe    80106f05 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
80106ecc:	89 d8                	mov    %ebx,%eax
80106ece:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106ed1:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80106ed4:	f6 c1 01             	test   $0x1,%cl
80106ed7:	74 e7                	je     80106ec0 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80106ed9:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106edb:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106ee1:	c1 ee 0a             	shr    $0xa,%esi
80106ee4:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80106eea:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80106ef1:	85 f6                	test   %esi,%esi
80106ef3:	74 cb                	je     80106ec0 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80106ef5:	8b 06                	mov    (%esi),%eax
80106ef7:	a8 01                	test   $0x1,%al
80106ef9:	75 15                	jne    80106f10 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
80106efb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f01:	39 da                	cmp    %ebx,%edx
80106f03:	77 c7                	ja     80106ecc <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106f05:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106f08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f0b:	5b                   	pop    %ebx
80106f0c:	5e                   	pop    %esi
80106f0d:	5f                   	pop    %edi
80106f0e:	5d                   	pop    %ebp
80106f0f:	c3                   	ret    
      if(pa == 0)
80106f10:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106f15:	74 25                	je     80106f3c <deallocuvm.part.0+0x9c>
      kfree(v);
80106f17:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106f1a:	05 00 00 00 80       	add    $0x80000000,%eax
80106f1f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106f22:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106f28:	50                   	push   %eax
80106f29:	e8 b2 b5 ff ff       	call   801024e0 <kfree>
      *pte = 0;
80106f2e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80106f34:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106f37:	83 c4 10             	add    $0x10,%esp
80106f3a:	eb 8c                	jmp    80106ec8 <deallocuvm.part.0+0x28>
        panic("kfree");
80106f3c:	83 ec 0c             	sub    $0xc,%esp
80106f3f:	68 06 7b 10 80       	push   $0x80107b06
80106f44:	e8 37 94 ff ff       	call   80100380 <panic>
80106f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106f50 <mappages>:
{
80106f50:	55                   	push   %ebp
80106f51:	89 e5                	mov    %esp,%ebp
80106f53:	57                   	push   %edi
80106f54:	56                   	push   %esi
80106f55:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106f56:	89 d3                	mov    %edx,%ebx
80106f58:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106f5e:	83 ec 1c             	sub    $0x1c,%esp
80106f61:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106f64:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106f68:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106f6d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106f70:	8b 45 08             	mov    0x8(%ebp),%eax
80106f73:	29 d8                	sub    %ebx,%eax
80106f75:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106f78:	eb 3d                	jmp    80106fb7 <mappages+0x67>
80106f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106f80:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106f82:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106f87:	c1 ea 0a             	shr    $0xa,%edx
80106f8a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106f90:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106f97:	85 c0                	test   %eax,%eax
80106f99:	74 75                	je     80107010 <mappages+0xc0>
    if(*pte & PTE_P)
80106f9b:	f6 00 01             	testb  $0x1,(%eax)
80106f9e:	0f 85 86 00 00 00    	jne    8010702a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106fa4:	0b 75 0c             	or     0xc(%ebp),%esi
80106fa7:	83 ce 01             	or     $0x1,%esi
80106faa:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106fac:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
80106faf:	74 6f                	je     80107020 <mappages+0xd0>
    a += PGSIZE;
80106fb1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106fb7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106fba:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106fbd:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80106fc0:	89 d8                	mov    %ebx,%eax
80106fc2:	c1 e8 16             	shr    $0x16,%eax
80106fc5:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106fc8:	8b 07                	mov    (%edi),%eax
80106fca:	a8 01                	test   $0x1,%al
80106fcc:	75 b2                	jne    80106f80 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106fce:	e8 cd b6 ff ff       	call   801026a0 <kalloc>
80106fd3:	85 c0                	test   %eax,%eax
80106fd5:	74 39                	je     80107010 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106fd7:	83 ec 04             	sub    $0x4,%esp
80106fda:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106fdd:	68 00 10 00 00       	push   $0x1000
80106fe2:	6a 00                	push   $0x0
80106fe4:	50                   	push   %eax
80106fe5:	e8 76 db ff ff       	call   80104b60 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106fea:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106fed:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106ff0:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106ff6:	83 c8 07             	or     $0x7,%eax
80106ff9:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106ffb:	89 d8                	mov    %ebx,%eax
80106ffd:	c1 e8 0a             	shr    $0xa,%eax
80107000:	25 fc 0f 00 00       	and    $0xffc,%eax
80107005:	01 d0                	add    %edx,%eax
80107007:	eb 92                	jmp    80106f9b <mappages+0x4b>
80107009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80107010:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107013:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107018:	5b                   	pop    %ebx
80107019:	5e                   	pop    %esi
8010701a:	5f                   	pop    %edi
8010701b:	5d                   	pop    %ebp
8010701c:	c3                   	ret    
8010701d:	8d 76 00             	lea    0x0(%esi),%esi
80107020:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107023:	31 c0                	xor    %eax,%eax
}
80107025:	5b                   	pop    %ebx
80107026:	5e                   	pop    %esi
80107027:	5f                   	pop    %edi
80107028:	5d                   	pop    %ebp
80107029:	c3                   	ret    
      panic("remap");
8010702a:	83 ec 0c             	sub    $0xc,%esp
8010702d:	68 54 81 10 80       	push   $0x80108154
80107032:	e8 49 93 ff ff       	call   80100380 <panic>
80107037:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010703e:	66 90                	xchg   %ax,%ax

80107040 <seginit>:
{
80107040:	55                   	push   %ebp
80107041:	89 e5                	mov    %esp,%ebp
80107043:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107046:	e8 a5 c9 ff ff       	call   801039f0 <cpuid>
  pd[0] = size-1;
8010704b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107050:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107056:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010705a:	c7 80 18 28 11 80 ff 	movl   $0xffff,-0x7feed7e8(%eax)
80107061:	ff 00 00 
80107064:	c7 80 1c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7e4(%eax)
8010706b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010706e:	c7 80 20 28 11 80 ff 	movl   $0xffff,-0x7feed7e0(%eax)
80107075:	ff 00 00 
80107078:	c7 80 24 28 11 80 00 	movl   $0xcf9200,-0x7feed7dc(%eax)
8010707f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107082:	c7 80 28 28 11 80 ff 	movl   $0xffff,-0x7feed7d8(%eax)
80107089:	ff 00 00 
8010708c:	c7 80 2c 28 11 80 00 	movl   $0xcffa00,-0x7feed7d4(%eax)
80107093:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107096:	c7 80 30 28 11 80 ff 	movl   $0xffff,-0x7feed7d0(%eax)
8010709d:	ff 00 00 
801070a0:	c7 80 34 28 11 80 00 	movl   $0xcff200,-0x7feed7cc(%eax)
801070a7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801070aa:	05 10 28 11 80       	add    $0x80112810,%eax
  pd[1] = (uint)p;
801070af:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801070b3:	c1 e8 10             	shr    $0x10,%eax
801070b6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801070ba:	8d 45 f2             	lea    -0xe(%ebp),%eax
801070bd:	0f 01 10             	lgdtl  (%eax)
}
801070c0:	c9                   	leave  
801070c1:	c3                   	ret    
801070c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801070d0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801070d0:	a1 c4 58 11 80       	mov    0x801158c4,%eax
801070d5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801070da:	0f 22 d8             	mov    %eax,%cr3
}
801070dd:	c3                   	ret    
801070de:	66 90                	xchg   %ax,%ax

801070e0 <switchuvm>:
{
801070e0:	55                   	push   %ebp
801070e1:	89 e5                	mov    %esp,%ebp
801070e3:	57                   	push   %edi
801070e4:	56                   	push   %esi
801070e5:	53                   	push   %ebx
801070e6:	83 ec 1c             	sub    $0x1c,%esp
801070e9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801070ec:	85 f6                	test   %esi,%esi
801070ee:	0f 84 cb 00 00 00    	je     801071bf <switchuvm+0xdf>
  if(p->kstack == 0)
801070f4:	8b 46 08             	mov    0x8(%esi),%eax
801070f7:	85 c0                	test   %eax,%eax
801070f9:	0f 84 da 00 00 00    	je     801071d9 <switchuvm+0xf9>
  if(p->pgdir == 0)
801070ff:	8b 46 04             	mov    0x4(%esi),%eax
80107102:	85 c0                	test   %eax,%eax
80107104:	0f 84 c2 00 00 00    	je     801071cc <switchuvm+0xec>
  pushcli();
8010710a:	e8 41 d8 ff ff       	call   80104950 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010710f:	e8 7c c8 ff ff       	call   80103990 <mycpu>
80107114:	89 c3                	mov    %eax,%ebx
80107116:	e8 75 c8 ff ff       	call   80103990 <mycpu>
8010711b:	89 c7                	mov    %eax,%edi
8010711d:	e8 6e c8 ff ff       	call   80103990 <mycpu>
80107122:	83 c7 08             	add    $0x8,%edi
80107125:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107128:	e8 63 c8 ff ff       	call   80103990 <mycpu>
8010712d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107130:	ba 67 00 00 00       	mov    $0x67,%edx
80107135:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
8010713c:	83 c0 08             	add    $0x8,%eax
8010713f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107146:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010714b:	83 c1 08             	add    $0x8,%ecx
8010714e:	c1 e8 18             	shr    $0x18,%eax
80107151:	c1 e9 10             	shr    $0x10,%ecx
80107154:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010715a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107160:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107165:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010716c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107171:	e8 1a c8 ff ff       	call   80103990 <mycpu>
80107176:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010717d:	e8 0e c8 ff ff       	call   80103990 <mycpu>
80107182:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107186:	8b 5e 08             	mov    0x8(%esi),%ebx
80107189:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010718f:	e8 fc c7 ff ff       	call   80103990 <mycpu>
80107194:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107197:	e8 f4 c7 ff ff       	call   80103990 <mycpu>
8010719c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801071a0:	b8 28 00 00 00       	mov    $0x28,%eax
801071a5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801071a8:	8b 46 04             	mov    0x4(%esi),%eax
801071ab:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801071b0:	0f 22 d8             	mov    %eax,%cr3
}
801071b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071b6:	5b                   	pop    %ebx
801071b7:	5e                   	pop    %esi
801071b8:	5f                   	pop    %edi
801071b9:	5d                   	pop    %ebp
  popcli();
801071ba:	e9 e1 d7 ff ff       	jmp    801049a0 <popcli>
    panic("switchuvm: no process");
801071bf:	83 ec 0c             	sub    $0xc,%esp
801071c2:	68 5a 81 10 80       	push   $0x8010815a
801071c7:	e8 b4 91 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
801071cc:	83 ec 0c             	sub    $0xc,%esp
801071cf:	68 85 81 10 80       	push   $0x80108185
801071d4:	e8 a7 91 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
801071d9:	83 ec 0c             	sub    $0xc,%esp
801071dc:	68 70 81 10 80       	push   $0x80108170
801071e1:	e8 9a 91 ff ff       	call   80100380 <panic>
801071e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071ed:	8d 76 00             	lea    0x0(%esi),%esi

801071f0 <inituvm>:
{
801071f0:	55                   	push   %ebp
801071f1:	89 e5                	mov    %esp,%ebp
801071f3:	57                   	push   %edi
801071f4:	56                   	push   %esi
801071f5:	53                   	push   %ebx
801071f6:	83 ec 1c             	sub    $0x1c,%esp
801071f9:	8b 45 0c             	mov    0xc(%ebp),%eax
801071fc:	8b 75 10             	mov    0x10(%ebp),%esi
801071ff:	8b 7d 08             	mov    0x8(%ebp),%edi
80107202:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107205:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010720b:	77 4b                	ja     80107258 <inituvm+0x68>
  mem = kalloc();
8010720d:	e8 8e b4 ff ff       	call   801026a0 <kalloc>
  memset(mem, 0, PGSIZE);
80107212:	83 ec 04             	sub    $0x4,%esp
80107215:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010721a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010721c:	6a 00                	push   $0x0
8010721e:	50                   	push   %eax
8010721f:	e8 3c d9 ff ff       	call   80104b60 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107224:	58                   	pop    %eax
80107225:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010722b:	5a                   	pop    %edx
8010722c:	6a 06                	push   $0x6
8010722e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107233:	31 d2                	xor    %edx,%edx
80107235:	50                   	push   %eax
80107236:	89 f8                	mov    %edi,%eax
80107238:	e8 13 fd ff ff       	call   80106f50 <mappages>
  memmove(mem, init, sz);
8010723d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107240:	89 75 10             	mov    %esi,0x10(%ebp)
80107243:	83 c4 10             	add    $0x10,%esp
80107246:	89 5d 08             	mov    %ebx,0x8(%ebp)
80107249:	89 45 0c             	mov    %eax,0xc(%ebp)
}
8010724c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010724f:	5b                   	pop    %ebx
80107250:	5e                   	pop    %esi
80107251:	5f                   	pop    %edi
80107252:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107253:	e9 a8 d9 ff ff       	jmp    80104c00 <memmove>
    panic("inituvm: more than a page");
80107258:	83 ec 0c             	sub    $0xc,%esp
8010725b:	68 99 81 10 80       	push   $0x80108199
80107260:	e8 1b 91 ff ff       	call   80100380 <panic>
80107265:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010726c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107270 <loaduvm>:
{
80107270:	55                   	push   %ebp
80107271:	89 e5                	mov    %esp,%ebp
80107273:	57                   	push   %edi
80107274:	56                   	push   %esi
80107275:	53                   	push   %ebx
80107276:	83 ec 1c             	sub    $0x1c,%esp
80107279:	8b 45 0c             	mov    0xc(%ebp),%eax
8010727c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
8010727f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107284:	0f 85 bb 00 00 00    	jne    80107345 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
8010728a:	01 f0                	add    %esi,%eax
8010728c:	89 f3                	mov    %esi,%ebx
8010728e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107291:	8b 45 14             	mov    0x14(%ebp),%eax
80107294:	01 f0                	add    %esi,%eax
80107296:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80107299:	85 f6                	test   %esi,%esi
8010729b:	0f 84 87 00 00 00    	je     80107328 <loaduvm+0xb8>
801072a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
801072a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
801072ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
801072ae:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
801072b0:	89 c2                	mov    %eax,%edx
801072b2:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
801072b5:	8b 14 91             	mov    (%ecx,%edx,4),%edx
801072b8:	f6 c2 01             	test   $0x1,%dl
801072bb:	75 13                	jne    801072d0 <loaduvm+0x60>
      panic("loaduvm: address should exist");
801072bd:	83 ec 0c             	sub    $0xc,%esp
801072c0:	68 b3 81 10 80       	push   $0x801081b3
801072c5:	e8 b6 90 ff ff       	call   80100380 <panic>
801072ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801072d0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801072d3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801072d9:	25 fc 0f 00 00       	and    $0xffc,%eax
801072de:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801072e5:	85 c0                	test   %eax,%eax
801072e7:	74 d4                	je     801072bd <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
801072e9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801072eb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
801072ee:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801072f3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801072f8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
801072fe:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107301:	29 d9                	sub    %ebx,%ecx
80107303:	05 00 00 00 80       	add    $0x80000000,%eax
80107308:	57                   	push   %edi
80107309:	51                   	push   %ecx
8010730a:	50                   	push   %eax
8010730b:	ff 75 10             	push   0x10(%ebp)
8010730e:	e8 9d a7 ff ff       	call   80101ab0 <readi>
80107313:	83 c4 10             	add    $0x10,%esp
80107316:	39 f8                	cmp    %edi,%eax
80107318:	75 1e                	jne    80107338 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
8010731a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107320:	89 f0                	mov    %esi,%eax
80107322:	29 d8                	sub    %ebx,%eax
80107324:	39 c6                	cmp    %eax,%esi
80107326:	77 80                	ja     801072a8 <loaduvm+0x38>
}
80107328:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010732b:	31 c0                	xor    %eax,%eax
}
8010732d:	5b                   	pop    %ebx
8010732e:	5e                   	pop    %esi
8010732f:	5f                   	pop    %edi
80107330:	5d                   	pop    %ebp
80107331:	c3                   	ret    
80107332:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107338:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010733b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107340:	5b                   	pop    %ebx
80107341:	5e                   	pop    %esi
80107342:	5f                   	pop    %edi
80107343:	5d                   	pop    %ebp
80107344:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80107345:	83 ec 0c             	sub    $0xc,%esp
80107348:	68 54 82 10 80       	push   $0x80108254
8010734d:	e8 2e 90 ff ff       	call   80100380 <panic>
80107352:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107360 <allocuvm>:
{
80107360:	55                   	push   %ebp
80107361:	89 e5                	mov    %esp,%ebp
80107363:	57                   	push   %edi
80107364:	56                   	push   %esi
80107365:	53                   	push   %ebx
80107366:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107369:	8b 45 10             	mov    0x10(%ebp),%eax
{
8010736c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
8010736f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107372:	85 c0                	test   %eax,%eax
80107374:	0f 88 b6 00 00 00    	js     80107430 <allocuvm+0xd0>
  if(newsz < oldsz)
8010737a:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
8010737d:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107380:	0f 82 9a 00 00 00    	jb     80107420 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80107386:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
8010738c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107392:	39 75 10             	cmp    %esi,0x10(%ebp)
80107395:	77 44                	ja     801073db <allocuvm+0x7b>
80107397:	e9 87 00 00 00       	jmp    80107423 <allocuvm+0xc3>
8010739c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
801073a0:	83 ec 04             	sub    $0x4,%esp
801073a3:	68 00 10 00 00       	push   $0x1000
801073a8:	6a 00                	push   $0x0
801073aa:	50                   	push   %eax
801073ab:	e8 b0 d7 ff ff       	call   80104b60 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801073b0:	58                   	pop    %eax
801073b1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801073b7:	5a                   	pop    %edx
801073b8:	6a 06                	push   $0x6
801073ba:	b9 00 10 00 00       	mov    $0x1000,%ecx
801073bf:	89 f2                	mov    %esi,%edx
801073c1:	50                   	push   %eax
801073c2:	89 f8                	mov    %edi,%eax
801073c4:	e8 87 fb ff ff       	call   80106f50 <mappages>
801073c9:	83 c4 10             	add    $0x10,%esp
801073cc:	85 c0                	test   %eax,%eax
801073ce:	78 78                	js     80107448 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
801073d0:	81 c6 00 10 00 00    	add    $0x1000,%esi
801073d6:	39 75 10             	cmp    %esi,0x10(%ebp)
801073d9:	76 48                	jbe    80107423 <allocuvm+0xc3>
    mem = kalloc();
801073db:	e8 c0 b2 ff ff       	call   801026a0 <kalloc>
801073e0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801073e2:	85 c0                	test   %eax,%eax
801073e4:	75 ba                	jne    801073a0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801073e6:	83 ec 0c             	sub    $0xc,%esp
801073e9:	68 d1 81 10 80       	push   $0x801081d1
801073ee:	e8 ad 92 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
801073f3:	8b 45 0c             	mov    0xc(%ebp),%eax
801073f6:	83 c4 10             	add    $0x10,%esp
801073f9:	39 45 10             	cmp    %eax,0x10(%ebp)
801073fc:	74 32                	je     80107430 <allocuvm+0xd0>
801073fe:	8b 55 10             	mov    0x10(%ebp),%edx
80107401:	89 c1                	mov    %eax,%ecx
80107403:	89 f8                	mov    %edi,%eax
80107405:	e8 96 fa ff ff       	call   80106ea0 <deallocuvm.part.0>
      return 0;
8010740a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107411:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107414:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107417:	5b                   	pop    %ebx
80107418:	5e                   	pop    %esi
80107419:	5f                   	pop    %edi
8010741a:	5d                   	pop    %ebp
8010741b:	c3                   	ret    
8010741c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107420:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107423:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107426:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107429:	5b                   	pop    %ebx
8010742a:	5e                   	pop    %esi
8010742b:	5f                   	pop    %edi
8010742c:	5d                   	pop    %ebp
8010742d:	c3                   	ret    
8010742e:	66 90                	xchg   %ax,%ax
    return 0;
80107430:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107437:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010743a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010743d:	5b                   	pop    %ebx
8010743e:	5e                   	pop    %esi
8010743f:	5f                   	pop    %edi
80107440:	5d                   	pop    %ebp
80107441:	c3                   	ret    
80107442:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107448:	83 ec 0c             	sub    $0xc,%esp
8010744b:	68 e9 81 10 80       	push   $0x801081e9
80107450:	e8 4b 92 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107455:	8b 45 0c             	mov    0xc(%ebp),%eax
80107458:	83 c4 10             	add    $0x10,%esp
8010745b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010745e:	74 0c                	je     8010746c <allocuvm+0x10c>
80107460:	8b 55 10             	mov    0x10(%ebp),%edx
80107463:	89 c1                	mov    %eax,%ecx
80107465:	89 f8                	mov    %edi,%eax
80107467:	e8 34 fa ff ff       	call   80106ea0 <deallocuvm.part.0>
      kfree(mem);
8010746c:	83 ec 0c             	sub    $0xc,%esp
8010746f:	53                   	push   %ebx
80107470:	e8 6b b0 ff ff       	call   801024e0 <kfree>
      return 0;
80107475:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010747c:	83 c4 10             	add    $0x10,%esp
}
8010747f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107482:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107485:	5b                   	pop    %ebx
80107486:	5e                   	pop    %esi
80107487:	5f                   	pop    %edi
80107488:	5d                   	pop    %ebp
80107489:	c3                   	ret    
8010748a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107490 <deallocuvm>:
{
80107490:	55                   	push   %ebp
80107491:	89 e5                	mov    %esp,%ebp
80107493:	8b 55 0c             	mov    0xc(%ebp),%edx
80107496:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107499:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010749c:	39 d1                	cmp    %edx,%ecx
8010749e:	73 10                	jae    801074b0 <deallocuvm+0x20>
}
801074a0:	5d                   	pop    %ebp
801074a1:	e9 fa f9 ff ff       	jmp    80106ea0 <deallocuvm.part.0>
801074a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074ad:	8d 76 00             	lea    0x0(%esi),%esi
801074b0:	89 d0                	mov    %edx,%eax
801074b2:	5d                   	pop    %ebp
801074b3:	c3                   	ret    
801074b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801074bf:	90                   	nop

801074c0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801074c0:	55                   	push   %ebp
801074c1:	89 e5                	mov    %esp,%ebp
801074c3:	57                   	push   %edi
801074c4:	56                   	push   %esi
801074c5:	53                   	push   %ebx
801074c6:	83 ec 0c             	sub    $0xc,%esp
801074c9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801074cc:	85 f6                	test   %esi,%esi
801074ce:	74 59                	je     80107529 <freevm+0x69>
  if(newsz >= oldsz)
801074d0:	31 c9                	xor    %ecx,%ecx
801074d2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801074d7:	89 f0                	mov    %esi,%eax
801074d9:	89 f3                	mov    %esi,%ebx
801074db:	e8 c0 f9 ff ff       	call   80106ea0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801074e0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801074e6:	eb 0f                	jmp    801074f7 <freevm+0x37>
801074e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074ef:	90                   	nop
801074f0:	83 c3 04             	add    $0x4,%ebx
801074f3:	39 df                	cmp    %ebx,%edi
801074f5:	74 23                	je     8010751a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801074f7:	8b 03                	mov    (%ebx),%eax
801074f9:	a8 01                	test   $0x1,%al
801074fb:	74 f3                	je     801074f0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801074fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107502:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107505:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107508:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010750d:	50                   	push   %eax
8010750e:	e8 cd af ff ff       	call   801024e0 <kfree>
80107513:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107516:	39 df                	cmp    %ebx,%edi
80107518:	75 dd                	jne    801074f7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010751a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010751d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107520:	5b                   	pop    %ebx
80107521:	5e                   	pop    %esi
80107522:	5f                   	pop    %edi
80107523:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107524:	e9 b7 af ff ff       	jmp    801024e0 <kfree>
    panic("freevm: no pgdir");
80107529:	83 ec 0c             	sub    $0xc,%esp
8010752c:	68 05 82 10 80       	push   $0x80108205
80107531:	e8 4a 8e ff ff       	call   80100380 <panic>
80107536:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010753d:	8d 76 00             	lea    0x0(%esi),%esi

80107540 <setupkvm>:
{
80107540:	55                   	push   %ebp
80107541:	89 e5                	mov    %esp,%ebp
80107543:	56                   	push   %esi
80107544:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107545:	e8 56 b1 ff ff       	call   801026a0 <kalloc>
8010754a:	89 c6                	mov    %eax,%esi
8010754c:	85 c0                	test   %eax,%eax
8010754e:	74 42                	je     80107592 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107550:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107553:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107558:	68 00 10 00 00       	push   $0x1000
8010755d:	6a 00                	push   $0x0
8010755f:	50                   	push   %eax
80107560:	e8 fb d5 ff ff       	call   80104b60 <memset>
80107565:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107568:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010756b:	83 ec 08             	sub    $0x8,%esp
8010756e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107571:	ff 73 0c             	push   0xc(%ebx)
80107574:	8b 13                	mov    (%ebx),%edx
80107576:	50                   	push   %eax
80107577:	29 c1                	sub    %eax,%ecx
80107579:	89 f0                	mov    %esi,%eax
8010757b:	e8 d0 f9 ff ff       	call   80106f50 <mappages>
80107580:	83 c4 10             	add    $0x10,%esp
80107583:	85 c0                	test   %eax,%eax
80107585:	78 19                	js     801075a0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107587:	83 c3 10             	add    $0x10,%ebx
8010758a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107590:	75 d6                	jne    80107568 <setupkvm+0x28>
}
80107592:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107595:	89 f0                	mov    %esi,%eax
80107597:	5b                   	pop    %ebx
80107598:	5e                   	pop    %esi
80107599:	5d                   	pop    %ebp
8010759a:	c3                   	ret    
8010759b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010759f:	90                   	nop
      freevm(pgdir);
801075a0:	83 ec 0c             	sub    $0xc,%esp
801075a3:	56                   	push   %esi
      return 0;
801075a4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801075a6:	e8 15 ff ff ff       	call   801074c0 <freevm>
      return 0;
801075ab:	83 c4 10             	add    $0x10,%esp
}
801075ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801075b1:	89 f0                	mov    %esi,%eax
801075b3:	5b                   	pop    %ebx
801075b4:	5e                   	pop    %esi
801075b5:	5d                   	pop    %ebp
801075b6:	c3                   	ret    
801075b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075be:	66 90                	xchg   %ax,%ax

801075c0 <kvmalloc>:
{
801075c0:	55                   	push   %ebp
801075c1:	89 e5                	mov    %esp,%ebp
801075c3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801075c6:	e8 75 ff ff ff       	call   80107540 <setupkvm>
801075cb:	a3 c4 58 11 80       	mov    %eax,0x801158c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801075d0:	05 00 00 00 80       	add    $0x80000000,%eax
801075d5:	0f 22 d8             	mov    %eax,%cr3
}
801075d8:	c9                   	leave  
801075d9:	c3                   	ret    
801075da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801075e0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801075e0:	55                   	push   %ebp
801075e1:	89 e5                	mov    %esp,%ebp
801075e3:	83 ec 08             	sub    $0x8,%esp
801075e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801075e9:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801075ec:	89 c1                	mov    %eax,%ecx
801075ee:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801075f1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801075f4:	f6 c2 01             	test   $0x1,%dl
801075f7:	75 17                	jne    80107610 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801075f9:	83 ec 0c             	sub    $0xc,%esp
801075fc:	68 16 82 10 80       	push   $0x80108216
80107601:	e8 7a 8d ff ff       	call   80100380 <panic>
80107606:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010760d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107610:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107613:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107619:	25 fc 0f 00 00       	and    $0xffc,%eax
8010761e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107625:	85 c0                	test   %eax,%eax
80107627:	74 d0                	je     801075f9 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107629:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010762c:	c9                   	leave  
8010762d:	c3                   	ret    
8010762e:	66 90                	xchg   %ax,%ax

80107630 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107630:	55                   	push   %ebp
80107631:	89 e5                	mov    %esp,%ebp
80107633:	57                   	push   %edi
80107634:	56                   	push   %esi
80107635:	53                   	push   %ebx
80107636:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107639:	e8 02 ff ff ff       	call   80107540 <setupkvm>
8010763e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107641:	85 c0                	test   %eax,%eax
80107643:	0f 84 bd 00 00 00    	je     80107706 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107649:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010764c:	85 c9                	test   %ecx,%ecx
8010764e:	0f 84 b2 00 00 00    	je     80107706 <copyuvm+0xd6>
80107654:	31 f6                	xor    %esi,%esi
80107656:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010765d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80107660:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107663:	89 f0                	mov    %esi,%eax
80107665:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107668:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010766b:	a8 01                	test   $0x1,%al
8010766d:	75 11                	jne    80107680 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010766f:	83 ec 0c             	sub    $0xc,%esp
80107672:	68 20 82 10 80       	push   $0x80108220
80107677:	e8 04 8d ff ff       	call   80100380 <panic>
8010767c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107680:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107682:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107687:	c1 ea 0a             	shr    $0xa,%edx
8010768a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107690:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107697:	85 c0                	test   %eax,%eax
80107699:	74 d4                	je     8010766f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010769b:	8b 00                	mov    (%eax),%eax
8010769d:	a8 01                	test   $0x1,%al
8010769f:	0f 84 9f 00 00 00    	je     80107744 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801076a5:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801076a7:	25 ff 0f 00 00       	and    $0xfff,%eax
801076ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801076af:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801076b5:	e8 e6 af ff ff       	call   801026a0 <kalloc>
801076ba:	89 c3                	mov    %eax,%ebx
801076bc:	85 c0                	test   %eax,%eax
801076be:	74 64                	je     80107724 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801076c0:	83 ec 04             	sub    $0x4,%esp
801076c3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801076c9:	68 00 10 00 00       	push   $0x1000
801076ce:	57                   	push   %edi
801076cf:	50                   	push   %eax
801076d0:	e8 2b d5 ff ff       	call   80104c00 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801076d5:	58                   	pop    %eax
801076d6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801076dc:	5a                   	pop    %edx
801076dd:	ff 75 e4             	push   -0x1c(%ebp)
801076e0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801076e5:	89 f2                	mov    %esi,%edx
801076e7:	50                   	push   %eax
801076e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801076eb:	e8 60 f8 ff ff       	call   80106f50 <mappages>
801076f0:	83 c4 10             	add    $0x10,%esp
801076f3:	85 c0                	test   %eax,%eax
801076f5:	78 21                	js     80107718 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
801076f7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801076fd:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107700:	0f 87 5a ff ff ff    	ja     80107660 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107706:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107709:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010770c:	5b                   	pop    %ebx
8010770d:	5e                   	pop    %esi
8010770e:	5f                   	pop    %edi
8010770f:	5d                   	pop    %ebp
80107710:	c3                   	ret    
80107711:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107718:	83 ec 0c             	sub    $0xc,%esp
8010771b:	53                   	push   %ebx
8010771c:	e8 bf ad ff ff       	call   801024e0 <kfree>
      goto bad;
80107721:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107724:	83 ec 0c             	sub    $0xc,%esp
80107727:	ff 75 e0             	push   -0x20(%ebp)
8010772a:	e8 91 fd ff ff       	call   801074c0 <freevm>
  return 0;
8010772f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107736:	83 c4 10             	add    $0x10,%esp
}
80107739:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010773c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010773f:	5b                   	pop    %ebx
80107740:	5e                   	pop    %esi
80107741:	5f                   	pop    %edi
80107742:	5d                   	pop    %ebp
80107743:	c3                   	ret    
      panic("copyuvm: page not present");
80107744:	83 ec 0c             	sub    $0xc,%esp
80107747:	68 3a 82 10 80       	push   $0x8010823a
8010774c:	e8 2f 8c ff ff       	call   80100380 <panic>
80107751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107758:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010775f:	90                   	nop

80107760 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107760:	55                   	push   %ebp
80107761:	89 e5                	mov    %esp,%ebp
80107763:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107766:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107769:	89 c1                	mov    %eax,%ecx
8010776b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010776e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107771:	f6 c2 01             	test   $0x1,%dl
80107774:	0f 84 00 01 00 00    	je     8010787a <uva2ka.cold>
  return &pgtab[PTX(va)];
8010777a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010777d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107783:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107784:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107789:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107790:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107792:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107797:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010779a:	05 00 00 00 80       	add    $0x80000000,%eax
8010779f:	83 fa 05             	cmp    $0x5,%edx
801077a2:	ba 00 00 00 00       	mov    $0x0,%edx
801077a7:	0f 45 c2             	cmovne %edx,%eax
}
801077aa:	c3                   	ret    
801077ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801077af:	90                   	nop

801077b0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801077b0:	55                   	push   %ebp
801077b1:	89 e5                	mov    %esp,%ebp
801077b3:	57                   	push   %edi
801077b4:	56                   	push   %esi
801077b5:	53                   	push   %ebx
801077b6:	83 ec 0c             	sub    $0xc,%esp
801077b9:	8b 75 14             	mov    0x14(%ebp),%esi
801077bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801077bf:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801077c2:	85 f6                	test   %esi,%esi
801077c4:	75 51                	jne    80107817 <copyout+0x67>
801077c6:	e9 a5 00 00 00       	jmp    80107870 <copyout+0xc0>
801077cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801077cf:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
801077d0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801077d6:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
801077dc:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
801077e2:	74 75                	je     80107859 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
801077e4:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801077e6:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
801077e9:	29 c3                	sub    %eax,%ebx
801077eb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801077f1:	39 f3                	cmp    %esi,%ebx
801077f3:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
801077f6:	29 f8                	sub    %edi,%eax
801077f8:	83 ec 04             	sub    $0x4,%esp
801077fb:	01 c1                	add    %eax,%ecx
801077fd:	53                   	push   %ebx
801077fe:	52                   	push   %edx
801077ff:	51                   	push   %ecx
80107800:	e8 fb d3 ff ff       	call   80104c00 <memmove>
    len -= n;
    buf += n;
80107805:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107808:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010780e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107811:	01 da                	add    %ebx,%edx
  while(len > 0){
80107813:	29 de                	sub    %ebx,%esi
80107815:	74 59                	je     80107870 <copyout+0xc0>
  if(*pde & PTE_P){
80107817:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010781a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010781c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010781e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107821:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107827:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010782a:	f6 c1 01             	test   $0x1,%cl
8010782d:	0f 84 4e 00 00 00    	je     80107881 <copyout.cold>
  return &pgtab[PTX(va)];
80107833:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107835:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010783b:	c1 eb 0c             	shr    $0xc,%ebx
8010783e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107844:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010784b:	89 d9                	mov    %ebx,%ecx
8010784d:	83 e1 05             	and    $0x5,%ecx
80107850:	83 f9 05             	cmp    $0x5,%ecx
80107853:	0f 84 77 ff ff ff    	je     801077d0 <copyout+0x20>
  }
  return 0;
}
80107859:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010785c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107861:	5b                   	pop    %ebx
80107862:	5e                   	pop    %esi
80107863:	5f                   	pop    %edi
80107864:	5d                   	pop    %ebp
80107865:	c3                   	ret    
80107866:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010786d:	8d 76 00             	lea    0x0(%esi),%esi
80107870:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107873:	31 c0                	xor    %eax,%eax
}
80107875:	5b                   	pop    %ebx
80107876:	5e                   	pop    %esi
80107877:	5f                   	pop    %edi
80107878:	5d                   	pop    %ebp
80107879:	c3                   	ret    

8010787a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
8010787a:	a1 00 00 00 00       	mov    0x0,%eax
8010787f:	0f 0b                	ud2    

80107881 <copyout.cold>:
80107881:	a1 00 00 00 00       	mov    0x0,%eax
80107886:	0f 0b                	ud2    
