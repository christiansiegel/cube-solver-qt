#ifndef QIMAGEITEM_H
#define QIMAGEITEM_H

#include <QtQuick/QQuickPaintedItem>
#include <QImage>

class QImageItem : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(QImage image READ image WRITE setImage)

public:
    QImageItem(QQuickItem *parent = 0);

    QImage image() const;
    void setImage(const QImage &image);

    void paint(QPainter *painter);

private:
    QImage m_image;
};

#endif //QIMAGEITEM_H
