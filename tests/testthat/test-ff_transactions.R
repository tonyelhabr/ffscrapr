with_mock_api({
  test_that("ff_transactions returns a tibble of transactions", {
    ssb <- mfl_connect(2019, 54040)
    ssb_transactions <- ff_transactions(ssb)

    dlf <- mfl_connect(2020, 37920)
    dlf_transactions <- ff_transactions(dlf)

    expect_tibble(ssb_transactions, min.rows = 100)
    expect_tibble(dlf_transactions, min.rows = 100)

    jml_conn <- ff_connect(platform = "sleeper", league_id = "522458773317046272", season = 2020)
    jml_transactions <- ff_transactions(jml_conn, week = 1:9)

    expect_tibble(jml_transactions, min.rows = 20)

    got_conn <- fleaflicker_connect(season = 2020, league_id = 206154)
    got_transactions <- ff_transactions(got_conn, franchise_id = 1373475)

    aaa_conn <- fleaflicker_connect(season = 2020, league_id = 312861)
    aaa_transactions <- ff_transactions(aaa_conn, franchise_id = 1581722)

    expect_tibble(aaa_transactions)
    expect_tibble(got_transactions)
  })
})
