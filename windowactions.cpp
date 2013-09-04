/*
Copyright (C) 2013  Mehmet IPEK

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>
*/

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
