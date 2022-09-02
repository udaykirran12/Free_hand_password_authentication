from flask import Flask, request, jsonify
import base64
import cv2
from matplotlib import pyplot as plt
import io
from imageio import imread
import numpy as np
from PIL import Image, ImageFile
import requests
import json
ImageFile.LOAD_TRUNCATED_IMAGES = True
app = Flask("__name__")
narray = np.array([])
@app.route('/both', methods = ["POST"])
def both():
    d={}
    similarity = "NO"
    request_data = request.data
    request_data = json.loads(request_data.decode('utf-8'))
    image_1 = request_data['image1']
    print(type(image_1))
    decoded_image1= base64.b64decode(image_1)
    i1 = Image.open(io.BytesIO(decoded_image1))
    #i1.show()
    img1 = np.array(i1) 
    print("IMAGE 1 IS: ")
    print(img1)
    gray_image1 = cv2.cvtColor(img1, cv2.COLOR_BGR2GRAY)
    size = gray_image1.size
    hist1= cv2.calcHist([gray_image1], [0],None, [256], [0, 256])
    image_2 = request_data['image2']
    decoded_image2= base64.b64decode(image_2)
    i2 = Image.open(io.BytesIO(decoded_image2))
    #i2.show()
    img2 = np.array(i2)
    print('IMAGE 2 IS : ')
    print(img2)
    gray_image2= cv2.cvtColor(img2,cv2.COLOR_BGR2GRAY)
    hist2 = cv2.calcHist([gray_image2],[0],None, [256], [0, 256])
    c=0
    i = 0
    while i<len(hist1) and i<len(hist2):
        c += (hist1[i]-hist2[i])**2
        i+=1
    c= c**(1/2)
    c = (c*100)/size
    print('C IS: ')
    print(c)
    if(c<=0.09):
        similarity = "YES"
    else:
        similarity = "NO"
    print("SIMILARITY IS:")
    print(similarity)
    d['output']=similarity
    return d
    # if(image_1!=decoded_image1 and image_2 != decoded_image2):
    #     d['output']= "success"
    # else :
    #     d['output']= "not"
    # return d
# @app.route('/imageone',methods = ["GET"])
# def imageone():
#     d={}
#     image1base = str(request.args['image1'])
#     image2base = str(request.args['image2'])
#     decodedImage1=base64.b64decode((image1base))
#     img1= imread(io.BytesIO(decodedImage1))
#     #narray= np.append(img) 
#     cv2_img = cv2.cvtColor(img1, cv2.COLOR_BGR2GRAY)
#     d['output']="success"
#     return d
# @app.route('/imagetwo',methods = ["GET"])
# def imagetwo():
#     d={}
#     image2base = str(request.args['image2'])
#     decodedImage2=base64.b64decode((image2base))
#     img2= imread(io.BytesIO(decodedImage2))
#     img22 = np.asarray(img2)
#     # narray = np.append(img22)
#     # print("size of narray is :")
#     # print(narray.size) 
#     cv2_img2 = cv2.cvtColor(img22, cv2.COLOR_BGR2GRAY)
#     d['output']="success"
#     return d


if __name__ =="__main__":
    app.run(debug = True)


# def from_base64(base64_data):
#     nparr = np.fromstring(base64_data.decode('base64'), np.uint8)
#     return cv2.imdecode(nparr, cv2.IMREAD_ANYCOLOR)




# b64_bytes = base64.b64encode(data)
# b64_string = b64_bytes.decode()

# # reconstruct image as an numpy array
# img = imread(io.BytesIO(base64.b64decode(b64_string)))

# # show image
# plt.figure()
# plt.imshow(img, cmap="gray")

# # finally convert RGB image to BGR for opencv
# # and save result
# cv2_img = cv2.cvtColor(img, cv2.COLOR_RGB2BGR)
# cv2.imwrite("reconstructed.jpg", cv2_img)
# plt.show()



    

    # img = Image.open(io.BytesIO(base64.decodebytes(bytes(image_1, "utf-8"))))
    # print(type(img))
    # img.save('my-image.jpg')
   # print("IMAGE1 IS :")