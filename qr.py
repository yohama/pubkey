import qrcode
from PIL import Image, ImageOps

fname = 'client_pubkey01'

def main():
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=10,
        border=4,
    )
    with open(fname + '.txt', 'r') as f:
        msg = f.read()
    qr.add_data(msg)
    qr.make()
    img = qr.make_image()
    img.save(fname + '.png')
    mirrored_img = ImageOps.mirror(img)
    mirrored_img.save(fname + '_mirror.png')

if __name__ == '__main__':
    main()