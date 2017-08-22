library(epian)

context('cpgi_annot()')

test_that('cpgi_annot() fails on empty input', {
  expect_error(cpgi_annot())
})

mock_tids = c(
  'cg20293725',
  'cg06464744',
  'cg26717016',
  'cg03401324',
  'cg08796898',
  'cg13836627',
  'cg19351350',
  'cg24248680',
  'cg16943083',
  'cg25920279'
)

test_that('cpgi_annot() fails on wrong method', {
  expect_error(cpgi_annot(mock_tids, method = 'chisk'))
})

test_that('cpgi_annot() fails on non-implemented architecture', {
  expect_error(cpgi_annot(mock_tids, arch = 'hm27'))
})

test_that('cpgi_annot() fails on non-implemented genome', {
  expect_error(cpgi_annot(mock_tids, genome = 'hg38'))
})

test_that('cpgi_annot() works as expected on correct inputs', {
  foo = cpgi_annot(
    probe_ids = mock_tids,
    method = 'chisq',
    arch = 'hm450',
    genome = 'hg19'
  )

  expect_true(all(foo[['Architecture']] == 'hm450'))
  expect_true(all(foo[['Genome']] == 'hg19'))
  expect_equal(nrow(foo), 6)
  expect_equal(ncol(foo), 19)
  expect_equal(foo[['CPGI_Status']], c('CGI', 'N_Shelf', 'N_Shore', 'Open_Sea',
                                       'S_Shelf', 'S_Shore'))
  expect_equal(foo[['Mark_And_SOI']], c(5, 0, 1, 2, 2, 4))
  expect_equal(foo[['Mark_And_Not_SOI']], c(209405, 76680, 121093, 117574,
                                            75847, 108505))
  expect_equal(foo[['Not_Mark_And_SOI']], c(5, 10, 9, 8, 8, 6))
  expect_equal(foo[['No_Mark_Or_SOI']], c(276162, 408887, 364474, 367993,
                                          409720, 377062))
  expect_equal(foo[['O_SOI']], c(1, 0, 0.111111111111111, 0.25, 0.25,
                                 0.666666666666667))
  expect_equal(foo[['O_Background']], c(0.758268697358797, 0.18753347501877,
                                        0.332240434159913, 0.319500642675268,
                                        0.185119105730743, 0.287764346447003))
  expect_equal(foo[['OR']], c(1.3187937250782, 0, 0.334429827579721,
                              0.782471039515539, 1.35048189117566,
                              2.31671044345115))
  expect_equal(foo[['Log2_OR']], c(0.399218927683493, -Inf, -1.58022456869379,
                                   -0.353890738267662, 0.433474294651592,
                                   1.21207773867751))
  expect_equal(foo[['P_SOI']], c(0.5, 0, 0.1, 0.2, 0.2, 0.4))
  expect_equal(foo[['P_Background']], c(0.431258714039463, 0.157918474690413,
                                        0.249384739902011, 0.242137542295914,
                                        0.156202954484139, 0.22346040814141))
  expect_equal(foo[['RR']], c(1.1593968625391, 0, 0.400986844821749,
                              0.825976831612431, 1.28038551294053,
                              1.79002626607069))
  expect_equal(foo[['Log2_RR']], c(0.213374486632077, -Inf, -1.3183731879372,
                                   -0.275826779812406, 0.356578258560408,
                                   0.839980757127467))
  expect_gt(min(foo[['P_Value']]), 0.05)
  expect_gt(min(foo[['FDR']]), 0.05)
  expect_equal(foo[['Bonferroni']], c(1, 1, 1, 1, 1, 1))
})


