import React from 'react'

import { withNamespaces } from '../../lib/i18n'

import {
  sortableContainer,
  sortableElement,
  sortableHandle
} from 'react-sortable-hoc'

import classNames from 'classnames'

import IconDrag from '../../svgs/icons/icon-drag.svg'
import IconDelete from '../../svgs/icons/icon-delete.svg'

const DragHandle = sortableHandle(() => (
  <div className='drag-handle'>
    <IconDrag fill='#FF6D6C' />
  </div>
))

const SortableItem = sortableElement(({ value, index, onChange, onDelete }) => (
  <li className='djn-file'>
    <DragHandle />
    <div className='track-position'>{index + 1}.</div>
    <fieldset>
      <input
        className='input'
        type='text'
        defaultValue={value.title}
        onChange={e => {
          const newTitle = e.target.value

          onChange(index, {
            title: newTitle
          })
        }}
      />
    </fieldset>
    <div className='delete' onClick={() => onDelete(index)}>
      <IconDelete fill='#FF6D6C' />
    </div>
  </li>
))

const SortableContainer = sortableContainer(({ className, children }) => (
  <ul className={className}>{children}</ul>
))

const TrackListComponent = ({ tracks, onSort, onChange, onDelete, t }) => {
  const empty = !Boolean(tracks.length)

  return (
    <SortableContainer
      onSortEnd={onSort}
      className={classNames('djn-files', {
        empty
      })}
      useDragHandle
    >
      {empty && <div>{t('album-tracks-placeholder')}</div>}
      {tracks.map((track, index) => (
        <SortableItem
          key={track.id}
          index={index}
          value={track}
          onChange={onChange}
          onDelete={onDelete}
        />
      ))}
    </SortableContainer>
  )
}

TrackListComponent.defaultProps = {
  onChange: () => {},
  onSort: () => {},
  onDelete: () => {}
}

export default withNamespaces('dashboard')(TrackListComponent)
