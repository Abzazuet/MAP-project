#ifndef MLX90614_H_
#define MLX90614_H_

#define MLX90614_I2CADDR_w     0xB4
#define MLX90614_I2CADDR_r     0xB5
// RAM
#define MLX90614_RAWIR1        0x04
#define MLX90614_RAWIR2        0x05
#define MLX90614_TA            0x06
#define MLX90614_TOBJ1         0x07
#define MLX90614_TOBJ2         0x08
// EEPROM
#define MLX90614_TOMAX         0x20
#define MLX90614_TOMIN         0x21
#define MLX90614_PWMCTRL       0x22
#define MLX90614_TARANGE       0x23
#define MLX90614_EMISS         0x24
#define MLX90614_CONFIG        0x25
#define MLX90614_ADDR          0x0E
#define MLX90614_ID1           0x3C
#define MLX90614_ID2           0x3D
#define MLX90614_ID3           0x3E
#define MLX90614_ID4           0x3F


void    TempC_Read(void);
void    TempCAmb(void);
uint16_t read_reg(uint8_t a);


#endif /* MLX90614_H_ */
