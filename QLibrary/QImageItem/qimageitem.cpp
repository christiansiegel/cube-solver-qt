#include "qimageitem.h"
#include <QPainter>

QImageItem::QImageItem(QQuickItem *parent)
    : QQuickPaintedItem(parent)
{
}

QImage QImageItem::image() const
{
    return m_image;
}

void QImageItem::setImage(const QImage &image)
{
    m_image = image;
    this->setWidth(image.width());
    this->setHeight(image.height());
    this->update();
}

void QImageItem::paint(QPainter *painter)
{
    painter->drawImage(0, 0, m_image);
}
