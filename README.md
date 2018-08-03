# Muzzy
Muzzy is mysql fuzzy importer for lazy (mainly japanese) people.

mysqlimport option is complex, just want to query tsv, csv on mysql client.

TSV or CSV query program are exist(textql, q, and something like that), but I wan't to use mysql client.

## Installation

$ gem install muzzy

and run bin/setup

## Usage

`$ muzzy [filename]`

or

`$ muzzy -f filename`


## Examples

### Case 1, You have Japanese tsv file

You have users.tsv and content is bellow.

```
性別	年齢	地域	車所有	デジカメ所有	パソコン所有	職業
男	10代	関東	無	有	有	学生
女	20代	関西	有	無	有	会社員
男	30代	中部	無	有	無	自営業
男	40代	東北	有	無	有	無職
女	10代	関東	無	有	無	学生
男	20代	関西	無	無	有	会社員
男	30代	東北	有	有	有	自営業
男	40代	関西	無	無	無	自由業
男	50代	関東	有	有	有	自由業
女	60代	九州	無	無	無	公務員
女	10代	四国	無	有	有	学生
女	10代	北海道	有	無	有	アルバイト
```

Therefore, you want to query users gender is '男', you can do as below.

```
$ muzzy users.tsv
$ mysql -u root muzzy
mysql> show create table users;
```

```
+--------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Table  | Create Table                                                                                                                                                                                                 |
+--------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| users | CREATE TABLE `users` (
  `seibetsu` text,
  `nenrei` text,
  `chiiki` text,
  `kurumashoyuu` text,
  `dejikameshoyuu` text,
  `pasokonshoyuu` text,
  `shokugyou` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8 |
+--------+--------------------------------------------
```

```
mysql> select * from sample where seibetsu  = '男';
+----------+--------+--------+--------------+----------------+---------------+-----------+
| seibetsu | nenrei | chiiki | kurumashoyuu | dejikameshoyuu | pasokonshoyuu | shokugyou |
+----------+--------+--------+--------------+----------------+---------------+-----------+
| 男       | 10代   | 関東   | 無           | 有             | 有            | 学生      |
| 男       | 30代   | 中部   | 無           | 有             | 無            | 自営業    |
| 男       | 40代   | 東北   | 有           | 無             | 有            | 無職      |
| 男       | 20代   | 関西   | 無           | 無             | 有            | 会社員    |
| 男       | 30代   | 東北   | 有           | 有             | 有            | 自営業    |
| 男       | 40代   | 関西   | 無           | 無             | 無            | 自由業    |
| 男       | 50代   | 関東   | 有           | 有             | 有            | 自由業    |
+----------+--------+--------+--------------+----------------+---------------+-----------+
7 rows in set (0.00 sec)
```

Thats, it.

## Dependency
muzzy uses [kakasi](http://kakasi.namazu.org/index.html.ja) for create table column name.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/muzzy. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Muzzy project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/muzzy/blob/master/CODE_OF_CONDUCT.md).
