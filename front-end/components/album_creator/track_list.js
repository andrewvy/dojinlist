import React from 'react'

import {
  sortableContainer,
  sortableElement,
  sortableHandle
} from 'react-sortable-hoc'

import classNames from 'classnames'

import IconDrag from '../../svgs/icons/icon-drag.svg'

const DragHandle = sortableHandle(() => <div className='drag-handle'><IconDrag fill='#FF6D6C'/></div>)

const SortableItem = sortableElement(({ value, index, onChange }) => (
  <li className='djn-file'>
    <DragHandle />
    <div className='track-position'>{index + 1}.</div>
    <fieldset>
      <input
        className='input'
        type='text'
        defaultValue={value.title}
        onChange={(e) => {
          const newTitle = e.target.value

          onChange(index, {
            title: newTitle
          })
        }}
      />
    </fieldset>
  </li>
))

const SortableContainer = sortableContainer(({ className, children }) => (
  <ul className={className}>{children}</ul>
))

const TrackListComponent = ({ tracks, onSort, onChange }) => (
  <SortableContainer
    onSortEnd={onSort}
    className={classNames('djn-files', {
      empty: !Boolean(tracks.length)
    })}
    useDragHandle
  >
    {tracks.map((track, index) => (
      <SortableItem
        key={track.id}
        index={index}
        value={track}
        onChange={onChange}
      />
    ))}
  </SortableContainer>
)

TrackListComponent.defaultProps = {
  onChange: () => {},
  onSort: () => {}
}

export default TrackListComponent
