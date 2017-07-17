#include "bluetoothclient.h"

#include <QDebug>
#include <QIODevice>
#include <QBluetoothAddress>
#include <QBluetoothUuid>

#define STX  0x02 /**< Signs the start of a message. */
#define ETX  0x03 /**< Signs the end of a message. */

BluetoothClient::BluetoothClient( QObject *parent) :
    QObject(parent)
{
    m_socket = new QBluetoothSocket(QBluetoothServiceInfo::RfcommProtocol, this);

    connect(m_socket, SIGNAL(readyRead()), this, SLOT(slotReadData()));
    connect(m_socket, SIGNAL(connected()), this, SLOT(slotConnected()));
    connect(m_socket, SIGNAL(disconnected()), this, SLOT(slotDisconnected()));
    connect(m_socket, SIGNAL(error(QBluetoothSocket::SocketError)), this, SLOT(slotError()));
}

void BluetoothClient::sendData(const QString &data)
{
    QByteArray stream;
    stream.append(STX);
    stream.append(data.toUtf8());
    stream.append(ETX);

    if (m_socket->state() == QBluetoothSocket::ConnectedState)
        m_socket->write(stream);
}

void BluetoothClient::connectTo(const QString &macAddress)
{
    if(m_socket->state() == QBluetoothSocket::UnconnectedState)
    {
        QBluetoothUuid uuid = QBluetoothUuid::Rfcomm;
        m_socket->connectToService(
                    QBluetoothAddress(macAddress),
                    uuid,
                    QIODevice::ReadWrite);
    }
}

void BluetoothClient::disconnect()
{
    m_socket->disconnectFromService();
}

void BluetoothClient::slotReadData()
{
    while (m_socket->bytesAvailable() > 0)
    {
        QByteArray line = m_socket->readLine();
        m_receivedData += QString::fromUtf8(line.constData(), line.length());
    }

    for(;;)
    {
        int start = m_receivedData.indexOf(STX);
        int end = m_receivedData.indexOf(ETX, start);

        if(start < 0 || end < start)
            break;

        int length = end - start - 1;
        QString telegram = m_receivedData.mid(start + 1, length);
        m_receivedData.remove(0, end + 1);

        emit telegramReceived(m_socket->peerAddress().toString(),
                    telegram);
    }
}

void BluetoothClient::slotConnected()
{
    emit connected(m_socket->peerAddress().toString(), m_socket->peerName());
}

void BluetoothClient::slotDisconnected()
{
    emit disconnected();
}

void BluetoothClient::slotError()
{
    emit error(m_socket->errorString());
}
