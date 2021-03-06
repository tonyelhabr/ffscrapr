with_mock_api({
  test_that("ff_transactions returns a tibble of starters", {
    dlf <- mfl_connect(2020, 37920)
    dlf_starters <- ff_starters(dlf, week = c(1:3), year = 2020)

    expect_tibble(dlf_starters, min.rows = 100)

    jml_conn <- sleeper_connect(league_id = "522458773317046272", season = 2020)
    jml_starters <- ff_starters(jml_conn)

    expect_tibble(jml_starters, min.rows = 100)

    got_conn <- fleaflicker_connect(season = 2020, league_id = 206154)
    got_starters <- ff_starters(got_conn, week = 4)

    expect_tibble(got_starters, min.rows = 100)
  })
})
