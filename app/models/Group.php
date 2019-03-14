<?php
class GroupModel extends BaseModel {
  const PERMISSION_DATA = 1, PERMISSION_REPAIR = 2, PERMISSION_MANAGE = 4;
  protected static $jsonFields = ['cheJian'];
}
