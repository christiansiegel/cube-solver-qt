#include "imageprocessor.h"
#include <QDebug>
#include <QColor>
#include <QCameraExposure>
#include <QPainter>

ImageProcessor::ImageProcessor(QObject *parent) :
    QObject(parent),
    m_imageCapture(0),
    m_processedImage(QImage(120, 120, QImage::Format_RGB32)),
    m_capturedSide(""),
    m_processingImage(false)
{
}

void ImageProcessor::setCameraObject(QObject *cameraObject)
{
    QVariant cameraVariant = cameraObject->property("mediaObject");
    QCamera *camera = qvariant_cast<QCamera*>(cameraVariant);

    if(m_imageCapture != 0)
        delete m_imageCapture;

    m_imageCapture = new QCameraImageCapture(camera, this);
    m_imageCapture->setCaptureDestination(QCameraImageCapture::CaptureToBuffer);

    QImageEncoderSettings encoder_setting = m_imageCapture->encodingSettings();
    encoder_setting.setCodec("image/jpeg");
    encoder_setting.setResolution(640, 480); // minimal working size
    m_imageCapture->setEncodingSettings(encoder_setting);

    connect(m_imageCapture, &QCameraImageCapture::imageAvailable,
            this, &ImageProcessor::processVideoFrame);
}

bool ImageProcessor::captureImage(const QString &side)
{
    if(m_imageCapture == 0)
        return false;

    if(!m_imageCapture->isReadyForCapture())
        return false;

    m_capturedSide = side;
    m_imageCapture->capture();
    m_processingImage = true;
    emit processingImageChanged();
    return true;
}



void ImageProcessor::processVideoFrame(int id, const QVideoFrame &frame)
{
    Q_UNUSED(id)

    if (!frame.isValid())
        return;

    QVideoFrame cloneFrame(frame);
    if (!cloneFrame.map(QAbstractVideoBuffer::ReadOnly))
        return;

    QImage originalImg;
    if(!originalImg.loadFromData(cloneFrame.bits(), cloneFrame.mappedBytes()))
        return;

    QTransform flipTransform;
    flipTransform.rotate(90);

    m_processedImage = originalImg
            .scaled(160, 120, Qt::KeepAspectRatio)
            .copy(20, 0, 120, 120)
            .transformed(flipTransform);

    QString facelets = "";

    facelets.append(cubeColorToString(processFacelet(QRect(0,  0, 40, 40), &m_processedImage)));
    facelets.append(cubeColorToString(processFacelet(QRect(40, 0, 40, 40), &m_processedImage)));
    facelets.append(cubeColorToString(processFacelet(QRect(80, 0, 40, 40), &m_processedImage)));

    facelets.append(cubeColorToString(processFacelet(QRect(0,  40, 40, 40), &m_processedImage)));
    facelets.append(cubeColorToString(processFacelet(QRect(40, 40, 40, 40), &m_processedImage)));
    facelets.append(cubeColorToString(processFacelet(QRect(80, 40, 40, 40), &m_processedImage)));

    facelets.append(cubeColorToString(processFacelet(QRect(0,  80, 40, 40), &m_processedImage)));
    facelets.append(cubeColorToString(processFacelet(QRect(40, 80, 40, 40), &m_processedImage)));
    facelets.append(cubeColorToString(processFacelet(QRect(80, 80, 40, 40), &m_processedImage)));

    emit processedImage(m_capturedSide, facelets);
    m_processingImage = false;
    emit processingImageChanged();
    cloneFrame.unmap();
}


ImageProcessor::CubeColor ImageProcessor::processFacelet(const QRect &area, QImage *image, const bool &fillFacelet, const bool &drawFaceletBorders) const
{
    QList<CubeColor> colors;
    for(int x = area.left(); x <= area.right(); ++x)
    for(int y = area.top(); y <= area.bottom(); ++y)
    {
        QColor color = QColor(image->pixel(x,y));
        CubeColor cubeColor = colorToCubeColor(color);
        colors.append(cubeColor);

        if (fillFacelet)
            image->setPixel(x, y, cubeColorToQColor(cubeColor).rgb());

        if (drawFaceletBorders
            && (x == area.left() || x == area.right() || y == area.top() || y == area.bottom()))
            image->setPixel(x, y, QColor::fromRgb(0, 0, 0).rgb());
    }

    CubeColor faceletColor = mostSignificantColor(colors);

    //QPainter p(image);
    //p.setPen(QPen(cubeColorToQColor(faceletColor)));
    //p.drawRect(area);

    return faceletColor;
}

ImageProcessor::CubeColor ImageProcessor::mostSignificantColor(const QList<CubeColor> &colors) const
{
    int bin[6] = {0};

    for (int i = 0; i < colors.size(); ++i)
        bin[colors.at(i)]++;

    int color = 0;
    for(int i = 0; i < 6; ++i)
        if(bin[i] >= bin[color])
            color = i;

    return static_cast<CubeColor>(color);
}


ImageProcessor::CubeColor ImageProcessor::colorToCubeColor(const QColor &color) const
{
     /*        H   S   V
     * rot:   348 100 100
     * blau:  210 100 100
     * grün:  180 100 100
     * gelb:   60 100 100
     * orange: 30 100 100
     * weiß:    0   0 100
     * schwarz: 0   0   0
     */

    const int satBorderWhiteColor = 50;

    const int hueBorderRedOrange = 10;
    const int hueBorderOrangeYellow = 40;
    const int hueBorderYellowGreen = 120;
    const int hueBorderGreenBlue = 195;
    const int hueBorderBlueRed = 280;

    int hue = color.hue(); // 0-359
    int sat = color.saturation(); // 0-255
    //int val = color.value(); // 0-255

    if(sat < satBorderWhiteColor)
        return WHITE;
    if(hue < hueBorderRedOrange)
        return RED;
    if(hue < hueBorderOrangeYellow)
        return ORANGE;
    if(hue < hueBorderYellowGreen)
        return YELLOW;
    if(hue < hueBorderGreenBlue)
        return GREEN;
    if(hue < hueBorderBlueRed)
        return BLUE;
    return RED;
}

QColor ImageProcessor::cubeColorToQColor(const ImageProcessor::CubeColor &cubeColor) const
{
    switch(cubeColor)
    {
    case RED:
        return QColor::fromRgb(255, 0, 0); // red
    case BLUE:
        return QColor::fromRgb(0, 0, 255); // blue
    case GREEN:
        return QColor::fromRgb(0, 255, 0); // green
    case YELLOW:
        return QColor::fromRgb(255, 255, 0); // yellow
    case ORANGE:
        return QColor::fromRgb(255, 165, 0); // orange
    case WHITE:
    default:
        return QColor::fromRgb(255, 255, 255); // white
    }
}

QString ImageProcessor::cubeColorToString(const ImageProcessor::CubeColor &cubeColor) const
{
    switch(cubeColor)
    {
    case RED:
        return "R"; // red
    case BLUE:
        return "B"; // blue
    case GREEN:
        return "G"; // green
    case YELLOW:
        return "Y"; // yellow
    case ORANGE:
        return "O"; // orange
    case WHITE:
    default:
        return "W"; // white
    }
}
