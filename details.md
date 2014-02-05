## Inputs
+ `/lua` 64000 characters limit.
+ `Chat Command` Chat input has 255 characters limit so max command length is 254.
+ `Popup Input` 254 characters limit.

## Functions
+ `print` 5000 characters limit. If you exceed the limit, it won't print the excess part of string.
+ `tfm.exec.chatMessage` You can't use img/a tags. If you do, it won't send the message.

#### ui.addTextArea
`INT id, STR text, STR name, INT x, INT y, INT w, INT h, INT bg, INT br, FLOAT opacity, BOOL isFixed`
+ `id` and `text` must be specified, others are optional.
+ `text` You can't use `http` and img tag in text. If you do, it will send you a warning message and won't show your textarea.
+ Max value is 32767 for `w` and `h`. (width and height)
+ `bg`
  + **0** *no background and no border*
  + **-1** *no background*

## Events
#### eventSummoningEnd
`STR name, INT type, INT posX, INT posY, INT angle, INT speedX, INT speedY, TABLE info`
```lua
info = {
  x = 51.9, -- posX = (x<0 and math.ceil or math.floor)(x * 10/3)
  y = 98.7, -- posY = (y<0 and math.ceil or math.floor)(y * 10/3)
  angle = 0,
  ghost = true,
  type = 0,
  id = 0,
}
```
