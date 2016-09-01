1.在分屏播放时不正常（应该是VLC的锅吧）

2.切换视频时内存一直没释放。（应该也是VLC的锅吧，并没有找到释放的方法）

3.切换视频和调整进度时容易崩 看日志有几种情况
1.Assertion failure in -[VLCMediaThumbnailer dealloc],
2.日志看起来 是和 Masonry 有冲突？不太确定


