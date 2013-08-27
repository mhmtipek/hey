#include "windowactions.h"

#include <QApplication>

WindowActions::WindowActions(QObject *parent) :
    QObject(parent)
{
    connect(qApp, SIGNAL(focusChanged(QWidget*,QWidget*)),
            this, SLOT(windowFocusChanged(QWidget *, QWidget *)));
}

bool WindowActions::hasFocus() const
{
    return m_hasFocus;
}

void WindowActions::windowFocusChanged(QWidget *old, QWidget *now)
{
    Q_UNUSED(old)

    m_hasFocus = (now != 0);

    emit focusChanged();
}
