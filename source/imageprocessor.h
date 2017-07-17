#ifndef IMAGEPROCESSOR_H
#define IMAGEPROCESSOR_H

#include <QObject>
#include <QCamera>
#include <QVideoFrame>
#include <QCameraImageCapture>

class ImageProcessor : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QImage processedImage READ getProcessedImage NOTIFY processedImage)
    Q_PROPERTY(bool processingImage READ getProcessingImage NOTIFY processingImageChanged)

public:
    explicit ImageProcessor(QObject *parent = 0);

    Q_INVOKABLE void setCameraObject(QObject *cameraObject);
    Q_INVOKABLE bool captureImage(const QString &side);
    QImage getProcessedImage() { return m_processedImage; }
    bool getProcessingImage() { return m_processingImage; }

private:
    enum CubeColor { WHITE = 0, RED, GREEN, BLUE, YELLOW, ORANGE };

    QCameraImageCapture * m_imageCapture;
    QImage m_processedImage;
    QString m_capturedSide;
    bool m_processingImage;

    CubeColor mostSignificantColor(const QList<CubeColor> &colors) const;
    CubeColor processFacelet(const QRect &area, QImage *image, const bool &fillFacelet = true, const bool &drawFaceletBorders = true) const;

    CubeColor colorToCubeColor(const QColor &color) const;
    QString cubeColorToString(const CubeColor &cubeColor) const;
    QColor cubeColorToQColor(const CubeColor &cubeColor) const;

private slots:
    void processVideoFrame(int id, const QVideoFrame &frame);

signals:
    void processedImage(const QString &side, const QString &facelets);
    void processingImageChanged();
};

#endif // IMAGEPROCESSOR_H
